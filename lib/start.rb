require 'fileutils'
require 'yaml'

class Start
  class << self
    public def copy_data_to_tmp
      configs = get_configs

      FileUtils.cp_r(configs['start_path'], configs['tmp_path'])
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
