MAS_FILE = File.expand_path("../package-managers/mas/app_store.txt", __dir__)

namespace :backup do
  desc 'Backup App Store'
  task :mas do
    section 'Backing up macOS App Store apps'

    run %( mas list \> #{MAS_FILE} )
  end
end

namespace :install do
  desc 'Install mas'
  task :mas do
    section 'Installing macOS App Store apps'

    if mas_applications.empty?
      log_warning("No macOS App Store apps to install")
    else
      mas_applications.each do |application|
        run %( mas install #{application} )
      end
    end
  end
end

def mas_applications
  File.readlines(MAS_FILE).map(&:split).map(&:first)
end
