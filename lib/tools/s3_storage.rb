# frozen_string_literal: true

require 'fog/aws'
require 'fileutils'
require 'pathname'

module Tools
  class S3Storage
    def initialize(configuration)
      @configuration = configuration
      @s3 = Fog::Storage.new(
        provider: 'AWS',
        region: configuration.region,
        aws_access_key_id: configuration.aws_access_key_id,
        aws_secret_access_key: configuration.aws_secret_access_key
      )
    end

    # Send files to S3.
    #
    # To test this, go to the console and execute:
    #
    # ```
    # file_path = "#{Rails.root}/Gemfile"
    # S3Storage.new.upload(file_path)
    # ```
    #
    # It will send the Gemfile to S3, inside the `remote_path` set in the
    # configuration. The bucket name and the credentials are also read from
    # the configuration.
    def upload(file_path, tags = '')
      file_name = Pathname.new(file_path).basename

      directory = s3.directories.new(key: bucket)
      directory.files.create(
        key: "#{remote_path}/#{file_name}",
        body: File.open(file_path),
        tags: tags
      )
    end

    # List all the files in the bucket's remote path. The result
    # is sorted in the reverse order, the most recent file will
    # show up first.
    #
    # Return an array of strings, containing only the file name.
    def list_files
      directory = s3.directories.get(bucket, prefix: remote_path)
      files = directory.files.map { |file| file.key }

      # The first item in the array is only the path an can be discarded.
      files = files.slice(1, files.length - 1) || []

      files
        .map { |file| Pathname.new(file).basename }
        .sort
        .reverse
    end

    # Get a specific file from the bucket's remote path.
    def get_file(file_name)
      directory = s3.directories.get(bucket, prefix: remote_path)
      directory.files.get("#{remote_path}/#{file_name}")
    end

    # Create a local file with the contents of the remote file.
    #
    # The new file will be saved in the `backup_folder` that was set
    # in the configuration (the default value is `db/backups`)
    def download(file_name)
      file_from_storage = get_file(file_name)
      local_file_path = "#{backup_folder}/#{file_name}"

      prepare_local_folder(local_file_path)
      File.open(local_file_path, 'w') do |local_file|
        body = file_body(file_from_storage)
        local_file.write(body)
      end
    end

    private

    attr_reader :configuration, :s3

    # Force UTF-8 encoding and remove the production environment from
    # the `ar_internal_metadata` table, unless the current Rails env
    # is indeed `production`.
    def file_body(file)
      body = file.body.force_encoding("UTF-8")
      return body if Rails.env.production?

      body.gsub('environment	production', "environment	#{Rails.env}")
    end

    def bucket
      @bucket ||= configuration.bucket
    end

    def region
      @region ||= configuration.region
    end

    def remote_path
      @remote_path ||= configuration.remote_path
    end

    def backup_folder
      @backup_folder ||= configuration.backup_folder
    end

    # Make sure the path exists and that there are no files with
    # the same name of the one that is being downloaded.
    def prepare_local_folder(local_file_path)
      FileUtils.mkdir_p(backup_folder)
      File.delete(local_file_path) if File.exist?(local_file_path)
    end
  end
end
