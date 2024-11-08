# frozen_string_literal: true

namespace :backup do
  desc 'Backup files'
  task :files, [:progress] do |_t, args|
    run %( /bin/date -u )

    section 'Using RCLONE to backup files'

    dirs = config['backup_dirs']

    flag = '-P' if args[:progress]

    dirs.each do |local, remote|
      run %( /opt/homebrew/bin/rclone sync #{flag} ~/#{local} koofr:#{remote} --filter-from ~/.config/rclone/filter_list.txt )
    end
  end
end

namespace :install do
  desc 'Install files'

  task :dotbot do
    section 'Using Dotbot to symlink dotfiles'

    if macos?
      run %( ./install-profile.sh macos )
    elsif linux?
      run %( ./install-profile.sh linux )
    else
      log_fail '~> Unknown OS'
    end
  end

  task :files do
    section 'Linking folders to their Git repository'

    run %( cd ~/.dotfiles && git init )
    run %( cd ~/.dotfiles && git remote add origin https://github.com/meaganewaller/dotfiles.git )
    run %( cd ~/.dotfiles && git fetch origin )
    run %( cd ~/.dotfiles && git reset origin/main )
  end
end

namespace :uninstall do
  desc 'Uninstall dotfiles'

  task :dotbot do
    section 'Uninstall Dotbot and restoring dotfiles'

    run %( ./uninstall )
  end
end

namespace :update do
  desc 'Update Dotbot'
  task :dotbot do
    section 'Updating Dotbot'
    run %( git submodule update --remote meta/dotbot )
    Rake::Task['install:dotbot'].invoke
  end
end
