class Copy
  class << self
      public def copy
        configs = get_configs
        full_path = configs['tmp_path'].to_s + configs['daniel-home'].to_s + '_*.tar.gz'

        FileUtils.cp(full_path, configs['backup_path'].to_s)
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
