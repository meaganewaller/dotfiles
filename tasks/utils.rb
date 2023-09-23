require 'rake'
require 'colorize'
require 'yaml'

def config
  YAML.load_file('config.yml')
end

def log_error(message)
  puts "[ERROR] #{message}".colorize(:red)
end

def log_warning(message)
  puts "[WARNING] #{message}".colorize(:yellow)
end

def log_info(message)
  puts "[INFO] #{message}".colorize(:blue)
end

def log_success(message)
  puts "[SUCCESS] #{message}".colorize(:green)
end

def log(message, color = :white)
  puts "#{message}".colorize(color)
end

def section(title, _description = '')
  seperator_count = (80 - title.length) / 2
  log(("\n" + '=' * seperator_count) + title.upcase + ('=' * seperator_count), :light_blue)
  log('~> Performing as dry run', :cyan) if ENV['DRY_RUN']
  log('~> Performing as super user', :red) if ENV['SUDO']
  log('~> Performing as test env user', :light_green) if ENV['TEST_ENV']
end

def run(cmd)
  log("~> 🚀#{cmd}")

  calling_file = File.basename(caller_locations[0].path)
  if ENV['TEST_ENV'] && !testable?(calling_file)
    log_info("~> Skipped (TEST_ENV) for #{calling_file}")
    return
  end

  if ENV['DRY_RUN']
    log_info("~> Skipped (DRY_RUN) for #{calling_file}")
    return
  end

  begin
    unless system(cmd)
      log_warning("~> Command failed: #{cmd}")
    else
      log_success("~> Completed for #{calling_file}")
    end
  rescue => e
    log_error("#{e.class}: #{e.message}")
  end
end

def yesno?(question)
  require 'highline/import'
  exit unless HighLine.agree(question)
end

def testable?(filename)
  !SKIP_TESTS_FOR.include?(filename)
end

def testing?
  ENV['TEST_ENV']
end

def find_replace(file_name, find, replace)
  file_name_new = file_name.gsub('~', ENV['HOME'])
  text = File.read(file_name_new)
  new_text = text.gsub(find, replace)

  # To write changes to the file, use:
  File.open(file_name_new, 'w') { |file| file.puts new_text }
end

def macos?
  system('uname -s | grep -q "Darwin"')
end

def linux?
  system('uname -s | grep -q "Linux"')
end
