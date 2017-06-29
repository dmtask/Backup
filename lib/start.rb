require 'fileutils'
require 'yaml'
require 'date'
require 'zlib'

require 'encrypt'
require 'upload'

class Start
  class << self
    # Starte...
    public def start
      configs = get_configs
      backup_name = ''

      if checks(configs)
        action 'Bereite Backupvorgang vor...' do
          backup_name = create_full_backup_name(configs)
        end

        unless backup_name.empty?
          create_tmp_directory(configs, backup_name)

          action 'Erstelle Backup...' do
            copy_data_to_tmp(configs, backup_name)
            compress_directory(configs, backup_name)
          end

          unless configs['develop']
            action "Kopiere Backup '#{configs['tmp_path']}#{backup_name}.tar.gz' auf die Backup Festplatte..." do
              copy_to_backup_volume(configs, backup_name)
            end

            if configs['encryption']
              action 'Verschlüssle Backup Archiv...' do
                Encrypt.encrypt(configs, backup_name)
              end
            end

            if configs['upload']
              action 'Lade Backup Archiv ins Google Drive...' do
                Upload.upload(configs, backup_name)
              end
            end
          end
        else
          error 'Vollständiger Backupname konnte nicht erstellt werden, Backupvorgang wurde abgebrochen.'
        end
      end
    end


    # Was muss auf jeden Fall gegeben sein, damit ein Backup funktioniert?
    private def checks(configs)
      if configs['develop']
        warn 'Backupscript befindet sich im Develop Modus!!'
        return true
      end

      if Process.euid != 0
        error 'Permission denied. Für den Backupvorgang werden Root Rechte benötigt.'
        return false
      end

      if configs['backup_path'].empty? || !Dir.open(configs['backup_path']).is_a?(Dir)
        error "Backup Festplatte unter '#{configs['backup_path']}' konnte nicht gefunden werden, Backupvorgang wurde abgebrochen."
        return false
      end

      return true
    end


    # Backup tmp Verzeichnis erstellen
    private def create_tmp_directory(configs, backup_name)
      FileUtils.mkdir_p(configs['tmp_path'].to_s + backup_name.to_s)
    end


    # Dateien ins tmp Verzeichnis kopieren
    private def copy_data_to_tmp(configs, backup_name)
      exclude_files = configs['exclude_files'].split('|')

      Dir[configs['start_path'].to_s + '*'].each do |file|
        unless exclude_files.include?(file[file.rindex('/') + 1, file.length])
          FileUtils.cp_r(file, (configs['tmp_path'].to_s + backup_name.to_s + '/'))
        end
      end

      # Alle .Dateien ebenfalls kopieren
      Dir[configs['start_path'].to_s + '.*'].each do |file|
        unless file.to_s.end_with?('..') || file.to_s.end_with?('.')
          FileUtils.cp_r(file, (configs['tmp_path'].to_s + backup_name.to_s + '/'))
        end
      end
    end


    # Backup Dateinamen mit Datum erstellen
    private def create_full_backup_name(configs)
      current_date = DateTime.now

      configs['backup_name'].to_s + '_' + current_date.strftime('%d-%m-%Y').to_s
    end


    # Archiv erstellen
    private def compress_directory(configs, backup_name)
      Dir.chdir(configs['tmp_path'].to_s)

      `tar -zcvf "#{backup_name}.tar.gz" "#{backup_name}/"`
    end


    # Archiv auf die Backupplatte kopieren
    private def copy_to_backup_volume(configs, backup_name)
      full_path = "#{configs['tmp_path']}#{backup_name}.tar.gz"

      FileUtils.cp(full_path, configs['backup_path'].to_s)
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
