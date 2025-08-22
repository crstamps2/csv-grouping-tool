require_relative '../../services/data_processor'

describe DataProcessor do
  let(:data) {
    [
      { email: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', zip: '94105' },
      { email: 'charlesch@gmail.com', firstname: 'Charles', lastname: 'Chou', phone: '(858) 888-8888', zip: '92064' },
      { email: 'joshs@home.com', firstname: 'Josh', lastname: 'Smith', phone: nil, zip: '94109' },
      { email: 'johns@home.com', firstname: 'Jon', lastname: 'Smithery', phone: '(555) 123-4567', zip: '94105' },
    ]
  }
  subject { described_class.call(data) }

  describe '#call' do
    it 'should return an array of hashes with id prepended to all hashes, having the same id for the same emails' do
      expect(subject).to eq([
        { id: 1, email: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', zip: '94105' },
        { id: 2, email: 'charlesch@gmail.com', firstname: 'Charles', lastname: 'Chou', phone: '(858) 888-8888', zip: '92064' },
        { id: 3, email: 'joshs@home.com', firstname: 'Josh', lastname: 'Smith', phone: nil, zip: '94109' },
        { id: 1, email: 'johns@home.com', firstname: 'Jon', lastname: 'Smithery', phone: '(555) 123-4567', zip: '94105' },
      ])
    end
  end
end
