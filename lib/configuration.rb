class Configuration
  attr_accessor :repository, :backup_folder, :bucket, :region, :file_suffix,
    :remote_path, :aws_access_key_id, :aws_secret_access_key

  def initialize(
    repository: 'file system',
    backup_folder: 'db/backups',
    file_suffix: '',
    aws_access_key_id: '',
    aws_secret_access_key: '',
    bucket: '',
    region: '',
    remote_path: '_backups/database/'
  )
    @repository = repository
    @backup_folder = backup_folder
    @file_suffix = file_suffix
    @aws_access_key_id = aws_access_key_id
    @aws_secret_access_key = aws_secret_access_key
    @bucket = bucket
    @region = region
    @remote_path = remote_path
  end

  def s3?
    repository.downcase == 's3'
  end
end
