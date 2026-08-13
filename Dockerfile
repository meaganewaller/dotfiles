# syntax=docker/dockerfile:1@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
FROM ubuntu:24.04@sha256:561618e2c15bf2397621dd04f96926663a3b5616c189cf7e38db7e82f5c538ea

ARG USERNAME=dev
ARG GIT_USER_NAME="Container User"
ARG GIT_USER_EMAIL="container@example.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV CONTAINER=docker
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
# install_chezmoi's own success check runs before ./install's own add_to_path
# call (see dotfiles-b73), so ~/.local/bin needs to already be on PATH before
# ./install starts — true by default in an interactive login shell via
# ~/.profile, but not in a non-interactive `docker build` RUN step.
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# jq: home/.chezmoiscripts/run_onchange_install-packages-linux.sh.tmpl skips
# system package installs entirely inside a container (they're supposed to
# already be baked into the image); jq is the one hard dependency that trips
# on a container without it (bin/sync-claude-extras requires it once `claude`
# is installed). See dotfiles-au4 — .packages.linux has no apt list at all
# today (only dnf), so this isn't only a container gap.
# unzip is the second: bin/install-password-manager runs as chezmoi's
# read-source-state.pre hook and unzips the 1Password CLI, so without it the
# hook exits 1 and chezmoi refuses to run at all -- the whole image build fails
# on "sudo: unzip: command not found". GitHub's runner image ships unzip, so
# this gap only ever showed in the container.
# openssh-client is the third: test/git-identity.bats validates every rendered
# allowed_signers line with `ssh-keygen -lf`, and a missing ssh-keygen exits
# 127, which the assertion reports as "not a valid ssh public key" — a real key
# blamed for a missing binary. Nothing in the dotfiles themselves shells out to
# ssh-keygen, so this is test-only today; it is installed rather than skipped
# because a suite that quietly drops assertions inside the container is worth
# less than the package it saves.
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git jq locales openssh-client sudo unzip zsh \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /usr/bin/zsh "${USERNAME}" \
    && printf '%s ALL=(ALL) NOPASSWD:ALL\n' "${USERNAME}" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}"

USER ${USERNAME}
WORKDIR /home/${USERNAME}/src/github.com/meaganewaller/dotfiles
COPY --chown=${USERNAME}:${USERNAME} . .

# --mount=type=secret (not ARG/ENV): ./install's `mise install` for the full
# user-global tool list makes dozens of unauthenticated GitHub API calls
# (60/hr limit); a token avoids the flakiness, same as bootstrap-dotfiles
# already does for CI. A secret mount, unlike ARG/ENV, never gets baked into
# image layer history — required=false means the build still works with no
# secret passed, it just risks rate-limit flakiness on the mise install step.
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN,required=false \
    GIT_USER_NAME="${GIT_USER_NAME}" \
    GIT_USER_EMAIL="${GIT_USER_EMAIL}" \
    WORK_PROFILE=false \
    ./install

SHELL ["/usr/bin/zsh", "-lc"]
CMD ["zsh", "-l"]
