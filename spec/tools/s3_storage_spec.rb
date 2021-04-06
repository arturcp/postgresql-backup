require_relative '../../lib/tools/s3_storage'
require_relative '../configuration_spec'

RSpec.describe Tools::S3Storage do
  let(:remote_path) { 'db/data' }
  let(:local_path) { 'db/local/backups' }
  let(:configuration) do
    Configuration.new(
      remote_path: remote_path,
      backup_folder: local_path,
      bucket: 'my-bucket'
    )
  end
  subject(:storage) { described_class.new(configuration) }

  describe '#upload' do
    let(:remote_file) { double(create: '') }

    before do
      allow(subject).to receive(:remote_file).and_return(remote_file)
      allow(File).to receive(:open).and_return('file body')
    end

    it 'sends the file to the remote repository' do
      expect(remote_file).to receive(:create).with(
        key: 'db/data/backup_file.sql',
        body: 'file body',
        tags: 'production-backup'
      )

      subject.upload('/rails-app/db/backups/backup_file.sql', 'production-backup')
    end
  end

  describe '#list_files' do
    let(:files) do
      [
        double(key: 'directory'),
        double(key: '202104121053_my-second-file.sql'),
        double(key: '202104150922_my-third-file.sql'),
        double(key: '202104100707_my-first-file.sql')
      ]
    end

    before do
      allow(subject).to receive(:remote_directory).and_return(double(files: files))
    end

    it 'lists the remote files and shows the most recent first' do
      expect(subject.list_files).to eq(['202104150922_my-third-file.sql', '202104121053_my-second-file.sql', '202104100707_my-first-file.sql'])
    end
  end

  describe '#download' do
    let(:file_name) { '202104150922_my-third-file.sql' }
    let(:local_file_path) { File.join('db/local/backups', file_name) }
    let(:files) { double(get: 'file content') }

    before do
      allow(subject).to receive(:remote_directory).and_return(double(files: files))

      expect(subject).to receive(:prepare_local_folder).with(local_file_path)
      expect(subject).to receive(:create_local_file).with(local_file_path, 'file content')
    end

    it 'returns the path to the newly created file' do
      expect(subject.download(file_name)).to eq(local_file_path)
    end
  end
end
