require 'backup'
require 'decrypt'

class Start
  class << self
    # Starte...
    public def start
      configs = get_configs

      if general_checks(configs)
        options = ['Backup starten', 'Backupdatei entschlüsseln']
        option = choose('Was möchten Sie machen?', options, default: options[0])

        if option == options[1]
          if configs['path_to_encryption_files'].empty? || !Dir.open(configs['path_to_encryption_files']).is_a?(Dir)
            error "Liste der verschlüsselten Archive unter '#{configs['path_to_encryption_files']}' konnte nicht gefunden werden, Entschlüsselung wurde abgebrochen."
          else
            Decrypt.decrypt(configs)
          end
        else
          if backup_checks(configs)
            Backup.backup(configs)
          end
        end
      end
    end


    # Was muss auf jeden Fall gegeben sein, damit das Script funktioniert?
    private def general_checks(configs)
      if configs['develop']
        warn 'Backupscript befindet sich im Develop Modus!!'
        return true
      end

      if Process.euid != 0
        error 'Permission denied. Für den Backupvorgang werden Root Rechte benötigt.'
        return false
      end

      return true
    end


    # Was muss für ein Backup alles gegeben sein, damit es funktioniert?
    private def backup_checks(configs)
      if configs['backup_path'].empty? || !Dir.open(configs['backup_path']).is_a?(Dir)
        error "Backup Festplatte unter '#{configs['backup_path']}' konnte nicht gefunden werden, Backupvorgang wurde abgebrochen."
        return false
      end

      if configs['start_path'].end_with?('/') && configs['tmp_path'].end_with?('/') && configs['backup_path'].end_with?('/')
        error 'Pfade in der backup.yml müssen mit einem / enden.'
        return false
      end

      return true
    end


    # Konfigurationen auslesen
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
