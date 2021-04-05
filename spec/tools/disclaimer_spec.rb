require_relative '../../lib/tools/disclaimer'

RSpec.describe Tools::Disclaimer do
  describe '#show' do
    subject(:disclaimer) { described_class.new(columns: 40, print_output: false) }
    let(:text) { 'Dolore ipsum sunt amet laborum voluptate elit tempor minim officia ex amet incididunt.' }

    context 'when there is no title' do
      context 'and there is a text' do
        it 'builds the disclaimer without the header' do
          expected_result = [
            '',
            '========================================',
            '|                                      |',
            '|  Dolore ipsum sunt amet laborum      |',
            '|  voluptate elit tempor minim         |',
            '|  officia ex amet incididunt.         |',
            '|                                      |',
            '========================================',
            ''
          ]

          output = disclaimer.show(texts: [text])
          expect(output).to eq(expected_result)
        end
      end

      context 'and there is not text' do
        it 'builds an empty box' do
          expected_result = [
            '',
            '========================================',
            '|                                      |',
            '|                                      |',
            '========================================',
            ''
          ]

          output = disclaimer.show
          expect(output).to eq(expected_result)
        end
      end

    end

    context 'when there is a title' do
      context 'and there is a text' do
        it 'builds the disclaimer with the header' do
          expected_result = [
            '',
            '========================================',
            '|                                      |',
            '|              My backup               |',
            '|                                      |',
            '========================================',
            '|                                      |',
            '|  Dolore ipsum sunt amet laborum      |',
            '|  voluptate elit tempor minim         |',
            '|  officia ex amet incididunt.         |',
            '|                                      |',
            '========================================',
            ''
          ]

          output = disclaimer.show(title: 'My backup', texts: [text])
          expect(output).to eq(expected_result)
        end
      end

      context 'and there is not text' do
        it 'builds the disclaimer with the header and an empty body' do
          expected_result = [
            '',
            '========================================',
            '|                                      |',
            '|              My backup               |',
            '|                                      |',
            '========================================',
            '|                                      |',
            '|                                      |',
            '========================================',
            ''
          ]

          output = disclaimer.show(title: 'My backup')
          expect(output).to eq(expected_result)
        end
      end
    end

    context 'with multiple texts' do
      context 'with two paragraphs' do
        it 'builds the disclaimer with both paragraphs' do
          expected_result = [
            '',
            '========================================',
            '|                                      |',
            '|              My backup               |',
            '|                                      |',
            '========================================',
            '|                                      |',
            '|  Dolore ipsum sunt amet laborum      |',
            '|  voluptate elit tempor minim         |',
            '|  officia ex amet incididunt.         |',
            '|  A second interesting paragraph.     |',
            '|                                      |',
            '========================================',
            ''
          ]

          output = disclaimer.show(title: 'My backup', texts: [text, 'A second interesting paragraph.'])
          expect(output).to eq(expected_result)
        end
      end

      context 'with an empty string in the texts list' do
        it 'builds the disclaimer with both paragraphs' do
          expected_result = [
            '',
            '========================================',
            '|                                      |',
            '|              My backup               |',
            '|                                      |',
            '========================================',
            '|                                      |',
            '|  Dolore ipsum sunt amet laborum      |',
            '|  voluptate elit tempor minim         |',
            '|  officia ex amet incididunt.         |',
            '|  A second interesting paragraph.     |',
            '|                                      |',
            '========================================',
            ''
          ]

          output = disclaimer.show(title: 'My backup', texts: [text, '', 'A second interesting paragraph.'])
          expect(output).to eq(expected_result)
        end
      end

      context 'with a blank space in the texts list' do
        it 'builds the disclaimer with all the texts, including a blank line for the blank space text' do
          expected_result = [
            '',
            '========================================',
            '|                                      |',
            '|              My backup               |',
            '|                                      |',
            '========================================',
            '|                                      |',
            '|  Dolore ipsum sunt amet laborum      |',
            '|  voluptate elit tempor minim         |',
            '|  officia ex amet incididunt.         |',
            '|                                      |',
            '|  A second interesting paragraph.     |',
            '|                                      |',
            '========================================',
            ''
          ]

          output = disclaimer.show(title: 'My backup', texts: [text, ' ', 'A second interesting paragraph.'])
          expect(output).to eq(expected_result)
        end
      end
    end
  end
end
