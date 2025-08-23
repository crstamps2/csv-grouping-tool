require_relative '../../services/csv_writer'
require 'csv'
require 'fileutils'

RSpec.describe CSVWriter do
  let(:output_path) { File.join('tmp', 'output.csv') }
  let(:original_headers) { ['Name', 'Phone', 'Email'] }

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

      subject { described_class.call(data, original_headers, output_path) }

      it 'writes the data to a CSV file' do
        subject

        expect(File.exist?(output_path)).to be true
      end

      it 'writes the correct headers and rows' do
        subject
        results = CSV.read(output_path, headers: true)

        expect(results.headers).to contain_exactly('ID', 'Name', 'Email', 'Phone')
        expect(results.length).to eq(2)

        expect(results[0]['ID']).to eq('1')
        expect(results[0]['Name']).to eq('Alice')
        expect(results[0]['phone']).to be_nil

        expect(results[1]['ID']).to eq('2')
        expect(results[1]['Name']).to eq('Bob')
        expect(results[1]['Email']).to eq('bob@example.com')
        expect(results[1]['Phone']).to eq('123-4567')
      end
    end

    context 'with empty data' do
      it 'does not create a file' do
        described_class.call([], original_headers, output_path)
        expect(File.exist?(output_path)).to be false
      end
    end

    context 'with nil data' do
      it 'does not create a file' do
        described_class.call(nil, original_headers, output_path)
        expect(File.exist?(output_path)).to be false
      end
    end
  end
end
