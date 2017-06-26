class Encrypt
  class << self
    # Archiv verschlüsseln
    public def encrypt(configs, backup_name)
      full_path = "#{configs['tmp_path']}#{backup_name}.tar.gz"

      # Ins Temp Verzeichnis wechseln
      Dir.chdir(configs['tmp_path'].to_s)

      # Verschlüsseln...
      `gpg -z 0 -c "#{full_path}"`
    end
  end
end
