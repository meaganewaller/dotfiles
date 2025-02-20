# frozen_string_literal: true

PIP_FILE = File.expand_path('../../tools/package-managers/mise/default-python-packages', __dir__)
PNPM_FILE = File.expand_path('../../tools/package-managers/mise/default-pnpm-packages', __dir__)
GEMS_FILE = File.expand_path('../../tools/package-managers/mise/default-gems', __dir__)
FONT_PATH = File.expand_path('../../fonts/', __dir__)

PIP_FILE_BACKUP = File.expand_path('../../tools/package-managers/mise/default-python-packages.bak', __dir__)
PNPM_FILE_BACKUP = File.expand_path('../../tools/package-managers/mise/default-pnpm-packages.bak', __dir__)
GEMS_FILE_BACKUP = File.expand_path('../../tools/package-managers/mise/default-gems.bak', __dir__)

# rubocop:disable Metrics/BlockLength
namespace :install do
  desc 'Install fonts'
  task :fonts do
    section 'Installing fonts'

    Dir.foreach(FONT_PATH) do |font|
      next if ['.', '..', '.DS_Store'].include?(font)

      escaped_path = FONT_PATH.gsub("'") { "\\'" }
      escaped_path = escaped_path.gsub(' ') { '\\ ' }
      font = font.gsub(' ') { '\\ ' }
      run %( cp #{escaped_path}/#{font} ~/Library/Fonts )
    end
  end

  desc 'Install mise'
  task :mise do
    section 'Installing mise package manager'

    if system('which mise')
      log_warning('mise is already installed. Skipping installation...')
    else
      log_info('mise is not installed. Proceeding with installation...')
      run %( /bin/bash curl https://mise.jdx.dev/mise-latest-macos-arm64 > ~/.local/bin/mise )
      log_success('mise installation completed successfully.')
    end

    log_info '~> Updating fish config'
    File.open("#{Dir.home}/.config/fish/config.fish", 'a') { |f| f.puts 'mise activate fish | source' }

    log_info '~> Adding mise completions to fish'
    run %( mkdir -p ~/.config/fish/completions )

    run %( mise use -g usage )
    run %( mise completion fish > ~/.config/fish/completions/mise.fish)

    log_success('mise completions installed')
  end

  namespace :mise do
    desc 'Install mise packages'
    task :packages do
      section 'Installing mise packages'

      # run %( mise install python 2.7.18 )
      # run %( mise install python 3.10.0 )
      # run %( mise global python 3.10.0 2.7.18 )
      # run %( ~/.mise/shims/python -m pip install --upgrade pip )
      # run %( ~/.asdf/shims/python -m pip install pynvim )
      # run %( ~/.asdf/shims/python2 -m pip install --upgrade pip )
      # run %( ~/.asdf/shims/python2 -m pip install pynvim )
      #
      # run %( asdf plugin add ruby )
      # run %( asdf install ruby 3.1.1 )
      # run %( asdf global ruby 3.1.1 )
      #
      # run %( asdf plugin add lua )
      # run %( asdf install lua 5.4.3 )
      # run %( asdf global lua 5.4.3 )
      #
      # run %( asdf plugin add postgres )
      # run %( asdf install postgres 14.0 )
      # run %( asdf global postgres 14.0 )
      # run %( ~/.asdf/installs/postgres/14.0/bin/pg_ctl -D ~/.asdf/installs/postgres/14.0/data -l logfile start )
      #
      # run %( asdf plugin add nodejs )
      # run %( asdf install nodejs latest )
      # run %( asdf global nodejs latest )
    end
  end

  desc 'Install macOS Configurations'
  task :macos do
    section 'Installing macOS Configurations'

    run %( sh ./commands/macos )
  end

  desc 'Install Neovim'
  task :neovim do
    section 'Installing Neovim'

    # time = Time.new.strftime('%s')
    # run %( asdf plugin add neovim )
    # run %( asdf install neovim nightly )
    # run %( rm -rf /usr/local/bin/nvim )
    # run %( rm -rf /usr/local/share/nvim )
  end

  desc 'Install Vim plugins'
  task :vim do
    section 'Installing Vim plugins'

    run %( mkdir ~/.vim/swp )
    run %( mkdir ~/.vim/undo )
    # rubocop:disable Layout/LineLength
    run %( curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim )
    # rubocop:enable Layout/LineLength
    run %( vim +PlugInstall +qall )
  end

  desc 'Install PIP files'
  task :pip do
    section 'Installing PIP files'

    run %( pip3 install -r #{PIP_FILE} )
  end

  desc 'Install PNPM files'
  task :pnpm do
    section 'Installing PNPM files'

    run %( xargs pnpm install --global \< #{PNPM_FILE} )
  end

  desc 'Install Ruby Gems'
  task :gems do
    section 'Installing Ruby Gems'

    run %( xargs gem install \< #{GEMS_FILE} )
  end

  desc 'Install Rust, Cargo and packages'
  task :cargo do
    section 'Installing Rust, Cargo and packages'

    # Install Rust and Cargo
    run %( curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh )

    # Install packages
    run %( cargo install cargo-update )
  end

  desc 'Install Fish'
  task :fish do
    section 'Installing Fish and plugins'

    run %( echo $(which fish) | sudo tee -a /etc/shells )
    run %( chsh -s $(which fish) )
    run %( curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher )
    run %( fisher list | fisher install )
  end

  desc 'Install Launch Agents'
  task :launchagents do
    section 'Installing Launch Agents'

    run %( launchctl load -w ~/Library/LaunchAgents/meagan.cloud-backup.plist )
    run %( launchctl load -w ~/Library/LaunchAgents/meagan.color-mode-notify.plist )
  end

  # As per:
  # https://blog.backtick.consulting/neovims-built-in-lsp-with-ruby-and-rails/
  desc 'Install Rails YARD directives'
  task :rails do
    section 'Installing Rails YARD directives'
    # rubocop:disable Layout/LineLength
    run %( git clone https://gist.github.com/castwide/28b349566a223dfb439a337aea29713e ~/.dotfiles/languages/ruby/enhance-rails-intellisense-in-solargraph )
    # rubocop:enable Layout/LineLength
  end

  desc 'Make dotfiles/bin executable'
  task :chmod_dots do
    section 'Making dotfiles/bin executable'

    run %( chmod -R +x ~/.dotfiles/bin/ )
  end

  desc 'Change Hammerspoon directory'
  task :hammerspoon do
    section 'Changing Hammerspoon directory'

    run %( defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua" )
  end

  # rubocop:disable Layout/LineLength
  desc 'Install writing tools'
  task :writing do
    section 'Installing writing tools'

    run %( curl -LSs https://github.com/errata-ai/proselint/releases/latest/download/proselint.zip --output /tmp/proselint.zip )
    run %( unzip /tmp/proselint.zip && mv ./proselint/ ~/.config/vale/ && rm -rf /tmp/proselint* )
    run %( curl -LSs https://github.com/errata-ai/alex/releases/latest/download/alex.zip --output /tmp/alex.zip)
    run %( unzip /tmp/alex.zip && mv ./alex/ ~/.config/vale/ && rm -rf /tmp/alex* )
    run %( curl -LSs https://github.com/errata-ai/write-good/releases/latest/download/write-good.zip --output /tmp/write-good.zip)
    run %( unzip /tmp/write-good.zip && mv ./write-good/ ~/.config/vale/ && rm -rf /tmp/write-good* )
  end
  # rubocop:enable Layout/LineLength
end
# rubocop:enable Metrics/BlockLength

# rubocop:disable Metrics/BlockLength
namespace :update do
  desc 'Patch fonts'
  task :fonts do
    section 'Patching fonts'

    fontforge_dir = File.expand_path('~/.fontforge')
    input_dir = File.expand_path('~/fonts_to_patch')
    output_dir = File.expand_path('~/patched_fonts')

    # Check if fontforge is installed
    run %( git clone https://github.com/ryanoasis/nerd-fonts ~/.fontforge ) unless File.directory?(fontforge_dir)

    yesno?("Have you copied fonts to the #{input_dir} folder?")

    run %( cd ~/.fontforge && git pull )
    Dir.foreach(input_dir) do |font|
      # rubocop:disable Layout/LineLength
      run %( cd ~/.fontforge && fontforge -script font-patcher --fontawesome --fontawesomeextension --fontlogos --octicons --codicons --powersymbols --pomicons --powerline --powerlineextra --material --weather --out #{output_dir} #{input_dir}/#{font} )
      # rubocop:enable Layout/LineLength
    end
  end

  desc 'Update Neovim'
  task :neovim do
    section 'Updating Neovim'

    run %( rm ~/.neovim/backup )
    run %( mv ~/.neovim/latest ~/.neovim/backup )
    Rake::Task['install:neovim'].invoke
  end

  desc 'Update Neovim plugins'
  task :neovim_plugins do
    section 'Updating Neovim plugins'

    run %( nvim --headless "+Lazy! sync" +qa )
  end

  desc 'Update Vim plugins'
  task :vim_plugins do
    section 'Updating Vim plugins'

    run %( vim +PlugUpdate +qall )
  end

  desc 'Update Rust'
  task :rust do
    section 'Updating Rust'

    run %( rustup update )
  end

  desc 'Update Cargo packages'
  task :cargo do
    section 'Updating Cargo packages'

    run %( cargo install-update -a )
  end

  desc 'Update PIP files'
  task :pip do
    section 'Updating PIP files'

    begin
      run %( pip3 install --upgrade pip )
      run %( pip3 freeze \> #{PIP_FILE} )
      find_replace(PIP_FILE, '==', '>=')
      run %( pip3 install -r #{PIP_FILE} --upgrade )
    rescue StandardError
      log_error 'PIP update failed'
    end
  end

  desc 'Update PNPM packages'
  task :pnpm do
    section 'Updating PNPM'

    run %( pnpm install -g pnpm && pnpm update -g )
  end

  desc 'Update Ruby Gems'
  task :gems do
    section 'Updating Ruby Gems'

    run %( gem update --system && gem update )
  end

  desc 'Update Fish'
  task :fish do
    section 'Updating Fish plugins'

    run %( fisher update )
  end

  desc 'Update Rails YARD directives'
  task :rails do
    section 'Updating Rails YARD directives'

    run %( git -C ~/.dotfiles/languages/ruby/enhance-rails-intellisense-in-solargraph pull )
  end

  desc 'Update Servers'
  task :servers do
    section 'Updating servers'

    # run %( asdf plugin update --all )
  end

  desc 'Update writing tools'
  task :writing do
    section 'Updating writing tools'

    run %( cd ~/.config/vale/proselint && git pull )
    run %( cd ~/.config/vale/alex && git pull )
    run %( cd ~/.config/vale/write-good && git pull )
  end
end
# rubocop:enable Metrics/BlockLength

namespace :rollback do
  desc 'Rollback Neovim'
  task :neovim do
    section 'Rolling back Neovim'

    run %( rm -rf /usr/local/bin/nvim )
    run %( rm -rf /opt/homebrew/bin/nvim )

    # Delete the most recent folder
    run %( cd ~/.neovim & rm -rf .DS_Store)
    run %( (cd ~/.neovim && ls -Art | tail -n 1 | xargs rm -rf) )

    # Restore Neovim from the previous nightly build
    # rubocop:disable Layout/LineLength
    run %( (cd ~/.neovim && ls -Art | fgrep -v .DS_Store | tail -n 1 | xargs -I{} cp -s ~/.neovim/{}/build/bin/nvim /usr/local/bin) )
    # rubocop:enable Layout/LineLength
  end
end
