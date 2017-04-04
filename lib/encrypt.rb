require 'rgpg'

class Encrypt
  class << self
    public def encrypt
      configs = get_configs
      full_path = configs['tmp_path'].to_s + configs['backup_name'].to_s + '_*.tar.gz'

      unless File.readable?(configs['keyfile'])
        generateKeyPair(configs)
      end

      Dir.chdir(configs['tmp_path'].to_s)
      Rgpg::GpgHelper.encrypt_file configs['keyfile'], full_path, full_path.to_s + '.enc'
    end


    private def generateKeyPair(configs)
      Rgpg::GpgHelper.generate_key_pair configs['key'], configs['email'], configs['name']
    end


    private def get_configs
      parsed = begin
        YAML.load(File.open("config/backup.yml"))
      rescue ArgumentError => e
        error "Kann YAML Config Datei nicht lesen: #{e.message}"
      end

      parsed
    end
  end
end
