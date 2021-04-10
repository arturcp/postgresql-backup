require_relative '../lib/configuration'

RSpec.describe Configuration do
  describe 'constructor' do
    context 'with default values' do
      subject { described_class.new }

      it { expect(subject.repository).to eq('file system') }
      it { expect(subject.backup_folder).to eq('db/backups') }
      it { expect(subject.file_suffix).to be_empty }
      it { expect(subject.aws_access_key_id).to be_empty }
      it { expect(subject.aws_secret_access_key).to be_empty }
      it { expect(subject.bucket).to be_empty }
      it { expect(subject.region).to be_empty }
      it { expect(subject.remote_path).to eq('_backups/database/') }
    end

    context 'with configuration values' do
      subject do
        described_class.new(
          repository: 'repository',
          backup_folder: 'backup_folder',
          file_suffix: 'file_suffix',
          aws_access_key_id: 'aws_access_key_id',
          aws_secret_access_key: 'aws_secret_access_key',
          bucket: 'bucket',
          region: 'region',
          remote_path: 'remote_path'
        )
      end

      it { expect(subject.repository).to eq('repository') }
      it { expect(subject.backup_folder).to eq('backup_folder') }
      it { expect(subject.file_suffix).to eq('file_suffix') }
      it { expect(subject.aws_access_key_id).to eq('aws_access_key_id') }
      it { expect(subject.aws_secret_access_key).to eq('aws_secret_access_key') }
      it { expect(subject.bucket).to eq('bucket') }
      it { expect(subject.region).to eq('region') }
      it { expect(subject.remote_path).to eq('remote_path') }
    end
  end

  describe '#s3?' do
    context 'when repository is set to S3' do
      subject { described_class.new(repository: 'S3') }
      it { expect(subject).to be_s3 }
    end

    context 'when repository is not set to S3' do
      subject { described_class.new(repository: 'file system') }
      it { expect(subject).not_to be_s3 }
    end
  end
end
