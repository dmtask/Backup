class Decrypt
  class << self
    # Archiv entschlüsseln
    public def decrypt(configs)
      decryption_file = list_all_backups(configs)

      # Entschlüsseln
      action "Entschlüssele Archiv '#{decryption_file}' ..." do
        `gpg --decrypt --output #{decryption_file.sub('.gpg', '')} #{decryption_file}`
      end
    end


    private def list_all_backups(configs)
      files = []

      Dir[configs['path_to_encryption_files'].to_s + '*.gpg'].each do |file|
        files.push(file)
      end

      choose('Welche Datei soll entschlüsselt werden?', files)
    end
  end
end
