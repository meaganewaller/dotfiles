MAS_FILE = File.expand_path("../../tools/package-managers/mas/app_store.txt", __dir__)
MAS_BACKUP_FILE = File.expand_path("../../tools/package-managers/mas/app_store.bak", __dir__)

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

    begin
      if mas_applications.empty?
        log_warning("No macOS App Store apps to install")
      else
        mas_applications.each do |application|
          run %( mas install #{application} )
        end
      end
    rescue => e
      log_error("[MAS]: Something went wrong install macOS App Store apps")
      log_error(e.message)
    end
  end
end

def mas_applications
  File.readlines(MAS_FILE).map(&:split).map(&:first)
end
