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
    # remote_path = 'database_backups'
    # S3Storage.new.upload(file_path, remote_path)
    # ```
    #
    # It will send the Gemfile to S3, inside a folder named `database_backups`.
    #
    # The bucket name and the credentials are read from the configuration file.
    def upload(local_file_path, remote_path, tags = '')
      file_name = Pathname.new(local_file_path).basename

      directory = s3.directories.new(key: bucket)
      directory.files.create(
        key: "#{remote_path}/#{file_name}",
        body: File.open(local_file_path),
        tags: tags
      )
    end

    # List all the files in the bucket's path.
    #
    # Return an array of string.
    def list_files(remote_path)
      directory = s3.directories.get(bucket, prefix: remote_path)
      files = directory.files.map { |file| file.key }

      # The first item in the array is only the path an can be discarded.
      files.slice(1, files.length - 1) || []
    end

    # Get a specific file from the bucket'path.
    def get_file(remote_path, file_name)
      directory = s3.directories.get(bucket, prefix: remote_path)
      directory.files.get("#{remote_path}/#{file_name}")
    end

    # Create a local file with the content of the remote file.
    #
    # The new file will be saved in the `backup_folder` set in the
    # configuration (the defaul value is `db/backups`)
    def download(remote_path:, remote_file_name:, local_path:, local_file_name:)
      file_from_storage = get_file(remote_path, remote_file_name)
      local_file_full_path = "#{local_path}/#{local_file_name}"

      prepare_local_folder(local_path, local_file_full_path)
      File.open(local_file_full_path, 'w') do |local_file|
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

    def prepare_local_folder(local_path, local_file_full_path)
      FileUtils.mkdir_p(local_path)
      File.delete(local_file_full_path) if File.exist?(local_file_full_path)
    end
  end
end
