require 'rgpg'

class Encrypt
  class << self
    public def encrypt(configs, backup_name)
      full_path = "#{configs['tmp_path']}#{backup_name}.tar.gz"

      unless File.readable?(configs['keyfile'])
        generateKeyPair(configs)
      end

      Dir.chdir(configs['tmp_path'].to_s)
      Rgpg::GpgHelper.encrypt_file configs['keyfile'], full_path, full_path.to_s + '.enc'
    end


    private def generateKeyPair(configs)
      Rgpg::GpgHelper.generate_key_pair configs['key'], configs['email'], configs['name']
    end
  end
end
