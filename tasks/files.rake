# frozen_string_literal: true

namespace :backup do
  desc 'Backup app config'
  task :mackup do
    section 'Using Mackup to backup app configs'

    if ENV['DRY_RUN']
      puts "~> No changes! It's a dry run"
      system %( mackup backup --dry-run )
    else
      run %( mackup backup --force )
    end
  end

  desc 'Backup files'
  task :files, [:progress] do |_t, args|
    run %( /bin/date -u )

    section 'Using RCLONE to backup files'

    dirs = {
      'dev' => 'dev',
      'workspace' => 'workspace',
      'code' => 'code',
      '.dotfiles' => '.dotfiles'
    }

    flag = '-P' if args[:progress]

    dirs.each do |local, remote|
      run %( /opt/homebrew/bin/rclone sync #{flag} ~/#{local} koofr:#{remote} --filter-from ~/.config/rclone/filter_list.txt )
    end
  end
end

namespace :install do
  desc 'Install files'

  task :mackup do
    section 'Installing Mackup'

    if !File.file?(File.expand_path('~/.mackup.cfg')) && !ENV['DRY_RUN']
      run %( ln -s #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER + File::SEPARATOR}.mackup.cfg #{'~' + File::SEPARATOR}.mackup.cfg )
      run %( ln -s #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER + File::SEPARATOR}.mackup #{'~' + File::SEPARATOR}.mackup )
    else
      puts '~> Already installed'
    end

    section 'Using Mackup to restore app configs'

    if ENV['DRY_RUN']
      puts "~> No changes! It's a dry run"
      system %( mackup restore --dry-run )
    else
      run %( mackup restore --force )
    end
  end

  task :dotbot do
    section 'Using Dotbot to symlink dotfiles'

    run %( ./install_profile macos )
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

  task :mackup do
    section 'Using Mackup to put app configs back'

    if ENV['DRY_RUN']
      puts '~> Just a dry run'
      system %( mackup uninstall --dry-run )
    else
      run %( mackup uninstall )
    end
  end

  task :dotbot do
    section 'Uninstall Dotbot and restoring dotfiles'

    run %( ./uninstall )
  end
end

namespace :update do
  desc 'Update Dotbot'
  task :dotbot do
    section 'Updating Dotbot'
    run %( git submodule update --remote dotbot )
    run %( ./install )
  end
end
