# syntax=docker/dockerfile:1
FROM ubuntu:24.04@sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90

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
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git jq locales sudo zsh \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /usr/bin/zsh "${USERNAME}" \
    && printf '%s ALL=(ALL) NOPASSWD:ALL\n' "${USERNAME}" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}"

USER ${USERNAME}
WORKDIR /home/${USERNAME}/src/github.com/meaganewaller/dotfiles
COPY --chown=${USERNAME}:${USERNAME} . .

# VERIFY_SIGNATURES=false: Debian/Ubuntu doesn't package chezmoi, so ./install
# falls back to a GitHub-release download here, and that fallback's cosign
# signature check is currently broken upstream — chezmoi stopped publishing
# the checksums.txt.sig/.pub pair install.sh expects, in favor of a Sigstore
# bundle (chezmoi_<version>_checksums.txt.sigstore.json). Tracked as
# dotfiles-xeo. sha256 checksum verification of the downloaded archive still
# runs unconditionally either way — this only skips the extra signature-of-
# the-checksums-file step.
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
    VERIFY_SIGNATURES=false \
    ./install

SHELL ["/usr/bin/zsh", "-lc"]
CMD ["zsh", "-l"]
