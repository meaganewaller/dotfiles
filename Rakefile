# --------------------------------------------
# frozen_string_literal: true

# Inspired by: https://github.com/kevinjalbert/dotfiles &
# https://github.com/olimorris/dotfiles
# --------------------------------------------

Dir.glob('./meta/tasks/**/*').map { |file| load file }

DOTS_FOLDER    = config['dots_folder']
DIRECTORY_NAME = config['directory_name']

task default: [:backup]

desc 'Backup all existing dotfiles'
task :backup do
  section 'Backing up'
  Rake::Task['backup:brew'].invoke if macos?
  Rake::Task['backup:mas'].invoke if macos?
  Rake::Task['backup:files'].invoke
  Rake::Task['backup:pip'].invoke
  Rake::Task['backup:pnpm'].invoke
  Rake::Task['backup:gems'].invoke
rescue StandardError => e
  log_error('[BACKUP]: Something went wrong! 😞')
  log_error(e.message)
end

desc 'MacOS only tasks'
task :install_macos do
  section 'Running macOS tasks'

  Rake::Task['install:brew'].invoke
  Rake::Task['install:brew_packages'].invoke
  Rake::Task['install:brew_cask_packages'].invoke
  Rake::Task['install:mas'].invoke
  Rake::Task['install:brew_clean_up'].invoke
  Rake::Task['install:fonts'].invoke
  Rake::Task['install:macos'].invoke
  Rake::Task['install:launchagents'].invoke
  Rake::Task['install:hammerspoon'].invoke
end

desc 'Install all new dotfiles'
task :install do
  section 'Installing'

  Rake::Task['install:dotbot'].invoke
  Rake::Task['install:mise'].invoke
  Rake::Task['install_macos'].invoke if macos?
  Rake::Task['install:servers'].invoke
  Rake::Task['install:neovim'].invoke
  Rake::Task['install:vim'].invoke
  Rake::Task['install:pip'].invoke
  Rake::Task['install:pnpm'].invoke
  Rake::Task['install:gems'].invoke
  Rake::Task['install:cargo'].invoke
  Rake::Task['install:zsh'].invoke
  # Rake::Task['install:rails'].invoke
  Rake::Task['install:chmod_dots'].invoke
  Rake::Task['install:writing'].invoke
rescue StandardError => e
  log_error('[INSTALL]: Something went wrong! 😞')
  log_error(e.message)
end

desc 'Update Everything'
task :update do
  section 'Updating'
  Rake::Task['update:brew'].invoke if macos?
  Rake::Task['update:dotbot'].invoke
  Rake::Task['update:neovim'].invoke
  Rake::Task['update:vim_plugins'].invoke
  Rake::Task['update:rust'].invoke
  Rake::Task['update:cargo'].invoke
  Rake::Task['update:pip'].invoke
  Rake::Task['update:pnpm'].invoke
  Rake::Task['update:gems'].invoke
  Rake::Task['update:fish'].invoke
  # Rake::Task['update:rails'].invoke
  Rake::Task['update:servers'].invoke
  Rake::Task['update:writing'].invoke
rescue StandardError => e
  log_error('[UPDATE]: Something went wrong! 😞')
  log_error(e.message)
end

desc 'Sync Everything'
task :sync do
  section '!! SYNCING !!'
  Rake::Task['update'].invoke
  Rake::Task['backup'].invoke
  Rake::Task['install:brew_clean_up'].invoke if macos?
rescue StandardError => e
  log_error('[SYNC]: Something went wrong! 😞')
  log_error(e.message)
end
