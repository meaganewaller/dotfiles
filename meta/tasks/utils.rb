require 'yaml'

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end

def config
  YAML.load_file('meta/config.yml')
end

def log_error(message)
  puts "[ERROR] #{message}".bold.bg_red
end

def log_warning(message)
  puts "[WARNING] #{message}".brown.italic
end

def log_info(message)
  puts "[INFO] #{message}".blue.bold
end

def log_success(message)
  puts "[SUCCESS] #{message}".green.bold
end

def log(message, color = :white)
  case color
  when :light_blue
    puts "#{message}".blue
  else
    puts "#{message}"
  end
end

def section(title, _description = '')
  seperator_count = (80 - title.length) / 2
  log(("\n" + '=' * seperator_count) + title.upcase + ('=' * seperator_count), :light_blue)
  log('~> Performing as dry run', :cyan) if ENV['DRY_RUN']
  log('~> Performing as super user', :red) if ENV['SUDO']
end

def run(cmd)
  log("~> 🚀#{cmd}")

  calling_file = File.basename(caller_locations[0].path)

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
