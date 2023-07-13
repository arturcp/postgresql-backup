require_relative '../lib/hooks'

RSpec.describe Hooks do
  subject(:hooks) { described_class.new(configuration_hooks) }

  context 'when configuration hooks is nil' do
    let(:configuration_hooks) { nil }

    it { expect(hooks.before_restore).to be_nil }
    it { expect(hooks.after_restore).to be_nil }
    it { expect(hooks.before_dump).to be_nil }
    it { expect(hooks.after_dump).to be_nil }
  end

  context 'when configuration hooks is set but the hook does not contain the expected method' do
    context 'but the hook class does not contain the expected methods' do
      let(:configuration_hooks) { double }

      it { expect(hooks.before_restore).to be_nil }
      it { expect(hooks.after_restore).to be_nil }
      it { expect(hooks.before_dump).to be_nil }
      it { expect(hooks.after_dump).to be_nil }
    end

    context 'and the hook is an instance of a class that contains the expected methods' do
      let(:my_class) do
        Class.new do
          def before_restore
            'before restore'
          end

          def after_restore
            'after restore'
          end

          def before_dump
            'before dump'
          end

          def after_dump
            'after dump'
          end
        end
      end

      let(:configuration_hooks) { my_class.new }

      it { expect(hooks.before_restore).to eq('before restore') }
      it { expect(hooks.after_restore).to eq('after restore') }
      it { expect(hooks.before_dump).to eq('before dump') }
      it { expect(hooks.after_dump).to eq('after dump') }
    end

    context 'and the hook is a class that contains the expected methods' do
      let(:my_class) do
        Class.new do
          def self.before_restore
            'before restore'
          end

          def self.after_restore
            'after restore'
          end

          def self.before_dump
            'before dump'
          end

          def self.after_dump
            'after dump'
          end
        end
      end

      let(:configuration_hooks) { my_class }

      it { expect(hooks.before_restore).to eq('before restore') }
      it { expect(hooks.after_restore).to eq('after restore') }
      it { expect(hooks.before_dump).to eq('before dump') }
      it { expect(hooks.after_dump).to eq('after dump') }
    end
  end
end
