require_relative '../../lib/tools/terminal'

RSpec.describe Tools::Terminal do
  describe '.spinner' do
    it 'starts the spin' do
      expect_any_instance_of(TTY::Spinner).to receive(:auto_spin).and_call_original
      described_class.spinner('testing the spinner') { true }
    end

    it 'returns the block value' do
      result = described_class.spinner('testing the spinner') { 10 }
      expect(result).to eq(10)
    end
  end
end
