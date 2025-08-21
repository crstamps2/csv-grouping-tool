describe CsvProcessor do
  subject { described_class.new }

  it 'should be able to count the number of rows, excluding the header row' do
    expect(subject.result.count).to eq(8)
  end
end
