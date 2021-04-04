# frozen_string_literal: true

require 'fog/aws'
require 'fileutils'
require 'pathname'

class S3Storage
  def initialize(bucket: ENV['S3_BUCKET_NAME'], region: ENV['AWS_REGION'])
    @bucket = bucket
    @region = region
    @s3 = Fog::Storage.new(
      provider: 'AWS',
      region: region,
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  # Send files to S3. It is very useful to save database
  # backups from times to times, for example.
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
  # The bucket name and the credentials are read from the env variables.
  def upload(local_file_path, remote_path, tags = '')
    file_name = Pathname.new(local_file_path).basename

    directory = s3.directories.new(key: bucket)
    directory.files.create(
      key: "#{remote_path}/#{file_name}",
      body: File.open(local_file_path),
      tags: tags
    )
  end

  def list_files(remote_path)
    files = s3.directories.get(bucket, prefix: remote_path).files.map do |file|
      file.key
    end

    files.slice(1, files.length - 1) || []
  end

  def get_file(remote_path, file_name)
    directory = s3.directories.get(bucket, prefix: remote_path)
    directory.files.get("#{remote_path}/#{file_name}")
  end

  def download(remote_path:, remote_file_name:, local_path:, local_file_name:)
    file_from_storage = get_file(remote_path, remote_file_name)
    local_file_full_path = "#{local_path}/#{local_file_name}"

    FileUtils.mkdir_p local_path
    File.delete(local_file_full_path) if File.exist?(local_file_full_path)
    File.open(local_file_full_path, 'w') do |local_file|
      body = file_body(file_from_storage)
      local_file.write(body)
    end
  end

  private

  attr_reader :bucket, :region, :s3

  def file_body(file)
    body = file.body.force_encoding("UTF-8")
    return body if Rails.env.production?

    body.gsub('environment	production', "environment	#{Rails.env}")
  end
end
