require_relative '../tools/disclaimer'
require_relative '../tools/terminal'
require_relative '../tools/database'
require_relative '../tools/s3_storage'
require 'tty-prompt'
require 'tty-spinner'
require 'pastel'

namespace :postgresql_backup do
  desc 'Dumps the database'
  task dump: :environment do
    title = pastel.yellow.bold('POSTGRESQL BACKUP')
    text = 'You are about to backup your database. Relax on your seat, this process is usually fast and you don\'t need to do anything except wait for the process to end. Here is the current configuration for this backup:'
    texts = [text, ' ', configuration_to_text].flatten
    disclaimer.show(title: title, texts: texts)
    file_path = ''

    Tools::Terminal.spinner('Backing up database') { file_path = db.dump }

    if configuration.s3?
      Tools::Terminal.spinner('Uploading file') { storage.upload(file_path, configuration.remote_path) }
      Tools::Terminal.spinner('Deleting local file') { File.delete(file_path) }  if File.exist?(file_path)
    end

    puts ''
    puts pastel.green('All done.')

    # prompt.select("Choose the file to restore?", %w(file1 file2 file3))
  end

  private

  def configuration
    @configuration ||= begin
      config = PostgresqlBackup.configuration.dup
      config.repository = ENV['BKP_REPOSITORY'] if ENV['BKP_REPOSITORY'].present?
      config.bucket = ENV['BKP_BUCKET'] if ENV['BKP_BUCKET'].present?
      config.region = ENV['BKP_REGION'] if ENV['BKP_REGION'].present?
      config.remote_path = ENV['BKP_REMOTE_PATH'] if ENV['BKP_REMOTE_PATH'].present?
      config
    end
  end

  def db
    @db ||= Tools::Database.new(configuration)
  end

  def storage
    @storage ||= Tools::S3Storage.new(configuration)
  end

  def disclaimer
    @disclaimer ||= Tools::Disclaimer.new
  end

  def pastel
    @pastel ||= Pastel.new
  end

  def prompt
    @prompt ||= TTY::Prompt.new
  end

  def configuration_to_text
    [
      show_config_for('Repository', configuration.repository),
      configuration.s3? ? nil : show_config_for('Folder', configuration.backup_folder),
      show_config_for('File suffix', configuration.file_suffix),
      configuration.s3? ? show_config_for('Bucket', configuration.bucket) : nil,
      configuration.s3? ? show_config_for('Region', configuration.region) : nil,
      configuration.s3? ? show_config_for('Remote path', configuration.remote_path) : nil
    ].compact
  end

  def show_config_for(text, value)
    return if value.empty?

    "* #{pastel.yellow.bold(text)}: #{value}"
  end
end
