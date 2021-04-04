module PostgresqlBackup
  class Configuration
    attr_reader :repository, :backup_folder, :aws_access_key_id,
      :aws_secret_access_key, :bucket, :region

    def initialize(
      repository: 'file system',
      backup_folder: 'db/backups',
      file_suffix: '',
      aws_access_key_id:,
      aws_secret_access_key:,
      bucket:,
      region:
    )
      @repository = repository
      @backup_folder = backup_folder
      @file_suffix = file_suffix
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
      @bucket = bucket
      @region = region
    end
  end
end
