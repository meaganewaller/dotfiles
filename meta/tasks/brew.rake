# frozen_string_literal: true
# This file contains tasks related to Homebrew

BACKUP_BREW_TAPS_FILE = File.expand_path("../../tools/package-managers/brew/taps.txt", __dir__)
BACKUP_BREW_PACKAGES_FILE = File.expand_path("../../tools/package-managers/brew/packages.txt", __dir__)
BACKUP_BREW_CASK_PACKAGES_FILE = File.expand_path("../../tools/package-managers/brew/cask.txt", __dir__)

BREW_PACKAGES_FILE = File.expand_path("../../tools/package-managers/brew/Brewfile", __dir__)
BREW_TAPS_FILE = File.expand_path("../../tools/package-managers/brew/Brewfile.taps", __dir__)
BREW_CASK_PACKAGES_FILE = File.expand_path("../../tools/package-managers/brew/Brewfile.cask", __dir__)

BREW_BACKUP_TASKS = %w(backup:brew_packages backup:brew_cask_packages backup:brew_taps)

HEAD_ONLY_FORMULAS = ''

namespace :backup do
  desc 'Backup Homebrew'
  task :brew do
    section 'Backing up Homebrew'

    run %( brew update )
    run %( brew upgrade )

    BREW_BACKUP_TASKS.each do |task|
      Rake::Task[task].invoke
    end
  end

  desc 'Backup Brew Packages'
  task :brew_packages do
    section 'Backing up Brew Packages'

    run %(brew leaves > #{BACKUP_BREW_PACKAGES_FILE} )

    log_info "~> Brew packages saved to #{BACKUP_BREW_PACKAGES_FILE}"
  end

  desc 'Backup Brew Cask Packages'
  task :brew_cask_packages do
    section 'Backing up Brew Cask Packages'

    run %( brew list --cask > #{BACKUP_BREW_CASK_PACKAGES_FILE} )

    log_info "~> Brew cask packages saved to #{BACKUP_BREW_CASK_PACKAGES_FILE}"
  end

  desc 'Backup Brew Taps'
  task :brew_taps do
    section 'Backing up Brew Taps Packages'

    run %( brew list --cask > #{BACKUP_BREW_TAPS_FILE} )

    log_info "~> Brew taps saved to #{BACKUP_BREW_TAPS_FILE}"
  end
end

namespace :install do
  desc 'Install XCode'
  task :xcode do
    section 'Installing XCode'

    run %( xcode-select --install )
  end

  desc 'Install Homebrew'
  task :brew do
    section 'Installing Homebrew'

    unless system('which brew')
      log_info("Homebrew is not installed. Proceeding with installation...")
      run %( /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" )
      log_success("Homebrew installation completed successfully.")
    else
      log_warning("Homebrew is already installed. Skipping installation...")
    end

    log_info "~> Updating brew directory permissions"
    run %( sudo chown -R $(whoami) /opt/homebrew/ )

    log_info "~> Installling brew taps"
    brew_taps.each do |tap|
      run %( brew tap #{tap} )
    end

    run %( brew analytics off )
  end

  desc 'Install Brew Packages'
  task :brew_packages do
    section 'Installing Brew Packages'
    install_packages(brew_packages)
  end

  desc 'Install Brew Cask Packages'
  task :brew_cask_packages do
    section 'Installing Brew Cask Packages'

    brew_cask_packages.each do |package|
      run %( brew install --force --appdir="/Applications" --fontdir="/Library/Fonts" #{package} )
    end
  end

  desc 'Clean up Brew'
  task :brew_clean_up do
    brew_cleanup
  end
end

namespace :update do
  desc 'Updating homebrew'
  task :brew do
    section 'Updating Homebrew'

    run %( brew update )
    run %( brew upgrade )
  end
end

def brew_taps
  File.readlines(BREW_TAPS_FILE).map(&:strip)
end

def brew_packages
  File.readlines(BREW_PACKAGES_FILE).map(&:strip)
end

def brew_taps
  File.readlines(BREW_TAPS_FILE).map(&:strip)
end

def brew_cask_packages
  File.readlines(BREW_CASK_PACKAGES_FILE).map(&:strip)
end

def install_packages(packages)
  packages.each do |package|
    if HEAD_ONLY_FORMULAS.include?(package)
      run %( brew install --HEAD ${package})
    else
      run %( brew install #{package})
    end
  end
end

def brew_cleanup
  section 'Cleaning up Brew'
  run %( brew cleanup )
end
