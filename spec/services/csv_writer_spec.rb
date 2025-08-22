require_relative '../../services/csv_writer'
require 'csv'
require 'fileutils'

RSpec.describe CSVWriter do
  let(:output_path) { File.join('tmp', 'output.csv') }

  after do
    FileUtils.rm_rf(output_path)
  end

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

      it 'writes the correct headers and rows' do
        described_class.call(data, output_path)

        # Read the file back to verify its contents
        results = CSV.read(output_path, headers: true)

        # Check headers (order might vary, so we check for presence)
        expect(results.headers).to contain_exactly('id', 'name', 'email', 'phone')

        # Check row count
        expect(results.length).to eq(2)

        # Check data integrity, row by row
        expect(results[0]['id']).to eq('1')
        expect(results[0]['name']).to eq('Alice')
        expect(results[0]['phone']).to be_nil # Correctly handles missing value

        expect(results[1]['id']).to eq('2')
        expect(results[1]['phone']).to eq('123-4567')
      end
    end

    context 'with empty data' do
      it 'does not create a file' do
        described_class.call([], output_path)
        expect(File.exist?(output_path)).to be false
      end
    end

    context 'with nil data' do
      it 'does not create a file' do
        described_class.call(nil, output_path)
        expect(File.exist?(output_path)).to be false
      end
    end
  end
end
