class Encrypt
  class << self
    public def encrypt

    end


    private def generateKeyPair

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
