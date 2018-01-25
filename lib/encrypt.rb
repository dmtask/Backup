class Encrypt
  class << self
    # Archiv verschlüsseln
    public def encrypt(configs, backup_name)
      full_path = "#{configs['tmp_path']}#{backup_name}.tar.gz"

      # Verschlüsseln...
      `gpg -z 0 -c "#{full_path}"`
    end
  end
end
