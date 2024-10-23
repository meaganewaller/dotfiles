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
  begin
    section 'Backing up'
    Rake::Task['backup:brew'].invoke
    Rake::Task['backup:mas'].invoke
    Rake::Task['backup:files'].invoke
    Rake::Task['backup:pip'].invoke
    Rake::Task['backup:pnpm'].invoke
    Rake::Task['backup:gems'].invoke
  rescue => e
    log_error("[BACKUP]: Something went wrong! 😞")
    log_error(e.message)
  end
end

desc 'Install all new dotfiles'
task :install do
  begin
    section 'Installing'

    Rake::Task['install:dotbot'].invoke
    Rake::Task['install:asdf'].invoke

    if macos?
      Rake::Task['install:brew'].invoke
      Rake::Task['install:brew_packages'].invoke
      Rake::Task['install:brew_cask_packages'].invoke
      Rake::Task['install:mas'].invoke
      Rake::Task['install:brew_clean_up'].invoke
      Rake::Task['install:fonts'].invoke
      Rake::Task['install:macos'].invoke
    end

    Rake::Task['install:servers'].invoke
    Rake::Task['install:neovim'].invoke
    Rake::Task['install:vim'].invoke
    Rake::Task['install:pip'].invoke
    Rake::Task['install:pnpm'].invoke
    Rake::Task['install:gems'].invoke
    Rake::Task['install:cargo'].invoke
    Rake::Task['install:fish'].invoke
    Rake::Task['install:launchagents'].invoke if macos?
    Rake::Task['install:rails'].invoke
    Rake::Task['install:chmod_dots'].invoke
    Rake::Task['install:hammerspoon'].invoke if macos?
    Rake::Task['install:writing'].invoke
  rescue => e
    log_error("[INSTALL]: Something went wrong! 😞")
    log_error(e.message)
  end
end

desc 'Update Everything'
task :update do
  begin
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
    Rake::Task['update:rails'].invoke
    Rake::Task['update:servers'].invoke
    Rake::Task['update:writing'].invoke
  rescue => e
    log_error("[UPDATE]: Something went wrong! 😞")
    log_error(e.message)
  end
end

desc 'Sync Everything'
task :sync do
  begin
    section '!! SYNCING !!'
    Rake::Task['update'].invoke
    Rake::Task['backup'].invoke
    Rake::Task['install:brew_clean_up'].invoke if macos?
  rescue => e
    log_error("[SYNC]: Something went wrong! 😞")
    log_error(e.message)
  end
end
