require_relative '../../services/csv_writer'
require 'csv'
require 'fileutils'

RSpec.describe CSVWriter do
  let(:output_path) { File.join('tmp', 'output.csv') }

  describe '.call' do
    context 'with data' do
      let(:data) do
        [
          { id: 1, name: 'Alice', email: 'alice@example.com' },
          { id: 2, name: 'Bob', email: 'bob@example.com', phone: '123-4567' } # Note: phone is a new key
        ]
      end

      it 'writes the data to a CSV file' do
        described_class.call(data, output_path)

        expect(File.exist?(output_path)).to be true
      end
    end
  end
end
