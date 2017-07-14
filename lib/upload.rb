require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Backupscript'
SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_METADATA_READONLY

class Upload
  class << self
    # Archiv ins Google Drive hochladen
    public def upload(configs, backup_name)
      service = Google::Apis::DriveV3::DriveService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize(configs)

      full_path = "#{configs['tmp_path']}#{backup_name}.tar.gz.gpg"
      upload_to_google_drive(full_path)
    end


    private def authorize(configs)
      credentials_path = configs['credentials_path']

      FileUtils.mkdir_p(File.dirname(credentials_path))

      client_id = Google::Auth::ClientId.from_file(configs['client_serects_path'])
      token_store = Google::Auth::Stores::FileTokenStore.new(file: credentials_path)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)

      #if credentials.nil?
      #  url = authorizer.get_authorization_url(base_url: OOB_URI)
      #  puts 'Open the following URL in the browser and enter the resulting code after authorization'
      #  puts url
      #  code = gets
      #  credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
      #end

      credentials
    end


    private def upload_to_google_drive(full_path)

    end
  end
end
