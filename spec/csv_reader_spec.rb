require_relative '../csv_reader'

describe CSVReader do
  subject { described_class.new('spec/fixtures/test.csv') }

  describe '#rows' do
    it 'should be able to count the number of rows, excluding the header row' do
      expect(subject.rows.count).to eq(8)
    end
    it 'returns a hash for each row' do
      rows = subject.rows
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
  end
end
