module PostgresqlBackup
  class Configuration
    attr_reader :repository, :backup_folder, :aws_access_key_id,
      :aws_secret_access_key, :bucket, :region

    def initialize(
      repository: 'file system',
      backup_folder: 'db/backups',
      aws_access_key_id:,
      aws_secret_access_key:,
      bucket:,
      region:
    )
      @backup_folder = backup_folder
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
      @bucket = bucket
      @region = region
    end
  end
end
