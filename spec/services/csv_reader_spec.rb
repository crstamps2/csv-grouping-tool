require_relative '../../services/csv_reader'

describe CSVReader do
  subject(:result) { described_class.call('spec/fixtures/test.csv') }

  let(:rows) { result[:rows] }
  let(:original_headers) { result[:original_headers] }

  describe '#rows' do
    it 'should be able to count the number of rows, excluding the header row' do
      expect(rows.count).to eq(8)
    end
    it 'returns a hash for each row' do
      expect(rows.first).to eq({
        email: "johns@home.com",
        firstname: "John",
        lastname: "Smith",
        phone: "(555) 123-4567",
        zip: "94105",
      })
      expect(rows.last).to eq({
        email: nil,
        firstname: "Josh",
        lastname: "Smith",
        phone: nil,
        zip: "94109",
      })
    end

    context 'when reading the headers' do
      it 'returns the original, case-sensitive headers' do
        expect(original_headers).to eq([
          "FirstName",
          "LastName",
          "Phone",
          "Email",
          "Zip"
        ])
      end
    end
  end
end
