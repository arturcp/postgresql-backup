module Tools
  class Database
    def initialize(configuration)
      @configuration = configuration
    end

    # Backup the database and save it on the backup folder set in the
    # configuration.
    #
    # Return the name, including the full path, of the backup file.
    def dump(debug: false)
      full_path = [
        "#{backup_folder}/#{Time.current.strftime('%Y%m%d%H%M%S')}",
        file_suffix,
        '.sql'
      ].join

      cmd = "PGPASSWORD='#{password}' pg_dump -F p -v -O -U '#{user}' -h '#{host}' -d '#{database}' -f '#{full_path}' -p '#{port}' "
      debug ? system(cmd) : system(cmd, err: File::NULL)

      full_path
    end

    private

    attr_reader :configuration

    def host
      @host ||= ActiveRecord::Base.connection_config[:host]
    end

    def port
      @port ||= ActiveRecord::Base.connection_config[:port]
    end

    def database
      @database ||= ActiveRecord::Base.connection_config[:database]
    end

    def user
      ActiveRecord::Base.connection_config[:username]
    end

    def password
      @password ||= ActiveRecord::Base.connection_config[:password]
    end

    def file_suffix
      return if configuration.file_suffix.empty?
      @file_suffix ||= "_#{configuration.file_suffix}"
    end

    def backup_folder
      @backup_folder ||= begin
        folder = File.join(Rails.root, configuration.backup_folder)
        FileUtils.mkdir_p(folder)
        folder
      end
    end
  end
end
