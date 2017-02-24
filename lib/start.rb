require 'fileutils'
require 'yaml'
require 'date'

class Start
  class << self
    public def start
      configs = get_configs

      backup_name = create_full_backup_name(configs)
      create_tmp_directory(configs, backup_name)
      copy_data_to_tmp(configs, backup_name)
    end


    private def create_tmp_directory(configs, backup_name)
      FileUtils.mkdir_p(configs['tmp_path'].to_s + backup_name.to_s)
    end


    private def copy_data_to_tmp(configs, backup_name)
      Dir[configs['start_path'].to_s + '*'].each do |file|
        FileUtils.cp_r(file, (configs['tmp_path'].to_s + backup_name.to_s + '/'))
      end
    end


    private def create_full_backup_name(configs)
      current_date = DateTime.now

      configs['backup_name'].to_s + '_' + current_date.strftime('%d-%m-%Y').to_s
    end


    private def get_configs
      parsed = begin
        YAML.load(File.open("config/backup.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
      end

      parsed
    end
  end
end
