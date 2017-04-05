require 'rgpg'

class Decrypt
  class << self
    public def decrypt(key_pub, key_sec, encrypted_file, file)
      Rgpg::GpgHelper.decrypt_file key_pub, key_sec, encrypted_file, file, ['secret_key_passphrase']
    end
  end
end
