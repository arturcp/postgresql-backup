require_relative '../spec_helper'
require_relative '../../lib/tools/database'
require_relative '../../lib/configuration'

RSpec.describe Tools::Database do
  let(:local_path) { 'db/local/backups' }
  let(:configuration) { Configuration.new(backup_folder: local_path) }
  subject(:database) { described_class.new(configuration) }

  before do
    allow(database).to receive(:backup_folder).and_return(local_path)
    allow(database).to receive(:password).and_return('')
    allow(database).to receive(:user).and_return('postgres')
    allow(database).to receive(:host).and_return('localhost')
    allow(database).to receive(:port).and_return('5432')
    allow(database).to receive(:database).and_return('test-database')
    allow(database).to receive(:system)
  end

  describe '#dump' do
    before { allow(subject).to receive(:file_name).and_return('20210406121523_backup_db') }
    let(:cmd) { "PGPASSWORD='' pg_dump -F p -v -O -U 'postgres' -h 'localhost' -d 'test-database' -f 'db/local/backups/20210406121523_backup_db.sql' -p '5432' " }

    context 'when debug is enabled' do
      let(:debug) { true }

      it 'executes pg_dump' do
        expect(database).to receive(:system).with(cmd)
        database.dump(debug: debug)
      end

      it { expect(database.dump(debug: debug)).to eq('db/local/backups/20210406121523_backup_db.sql') }
    end

    context 'when debug is not enabled' do
      let(:debug) { false }

      it 'executes pg_dump redirecting the output to a dark hole' do
        expect(database).to receive(:system).with(cmd, err: File::NULL)
        database.dump(debug: debug)
      end

      it { expect(database.dump(debug: debug)).to eq('db/local/backups/20210406121523_backup_db.sql') }
    end
  end

  describe '#restore' do
    let(:file_name) { '20210406121523_backup_db.sql' }
    let(:cmd) { "PGPASSWORD='' psql -U 'postgres' -h 'localhost' -d 'test-database' -f 'db/local/backups/20210406121523_backup_db.sql' -p '5432' " }

    context 'when debug is enabled' do
      let(:debug) { true }

      it 'executes psql restore' do
        expect(database).to receive(:system).with(cmd)
        database.restore(file_name, debug: debug)
      end

      it { expect(database.restore(file_name, debug: debug)).to eq('db/local/backups/20210406121523_backup_db.sql') }
    end

    context 'when debug is not enabled' do
      let(:debug) { false }

      it 'executes psql restore redirecting the output to a dark hole' do
        expect(database).to receive(:system).with("#{cmd} > /dev/null")
        database.restore(file_name, debug: debug)
      end

      it { expect(database.restore(file_name, debug: debug)).to eq('db/local/backups/20210406121523_backup_db.sql') }
    end
  end

  describe '#reset' do
    it 'calls rake db:drop' do
      expect(database).to receive(:system).with('bundle exec rake db:drop db:create')
      database.reset
    end
  end

  describe '#list_files' do
  end
end
