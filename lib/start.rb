require 'fileutils'
require 'yaml'
require 'date'
require 'zlib'

class Start
  class << self
    public def start
      configs = get_configs

      # TODO: Prüfen ob eine Backup Platte vorhanden ist
      # TODO: Schöne Ausgaben einbauen

      backup_name = create_full_backup_name(configs)
      create_tmp_directory(configs, backup_name)

      copy_data_to_tmp(configs, backup_name)

      compress_directory(configs, backup_name)
    end


    private def checks(configs)

    end


    private def create_tmp_directory(configs, backup_name)
      FileUtils.mkdir_p(configs['tmp_path'].to_s + backup_name.to_s)
    end


    private def copy_data_to_tmp(configs, backup_name)
      exclude_files = configs['exclude_files'].split('|')

      Dir[configs['start_path'].to_s + '*'].each do |file|
        if !exclude_files.include?(file[file.rindex('/') + 1, file.length])
          FileUtils.cp_r(file, (configs['tmp_path'].to_s + backup_name.to_s + '/'))
        end
      end
    end


    private def create_full_backup_name(configs)
      current_date = DateTime.now

      configs['backup_name'].to_s + '_' + current_date.strftime('%d-%m-%Y').to_s
    end


    private def compress_directory(configs, backup_name)
      Dir.chdir(configs['tmp_path'].to_s)

      `tar -zcvf "#{backup_name}.tar.gz" "#{backup_name}/"`
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
