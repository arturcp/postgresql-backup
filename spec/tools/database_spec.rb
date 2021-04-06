require_relative '../../lib/tools/database'
require_relative '../../lib/configuration'

RSpec.describe Tools::Database do
  let(:local_path) { 'db/local/backups' }
  let(:configuration) { Configuration.new(backup_folder: local_path) }
  subject(:database) { described_class.new(configuration) }

  describe '#dump' do
  end

  describe '#restore' do
  end

  describe '#reset' do
    it 'calls rake db:drop' do
      expect(subject).to receive(:system).with('bundle exec rake db:drop db:create')
      subject.reset
    end
  end

  describe '#list_files' do
  end
end
