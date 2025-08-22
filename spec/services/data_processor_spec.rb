require_relative '../../services/data_processor'

describe DataProcessor do
  let(:data) {
    [
      { email: '', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', zip: '94105' },
      { email: 'charlesch@gmail.com', firstname: 'Charles', lastname: 'Chou', phone: '(858) 888-8888', zip: '92064' },
      { email: 'joshs@home.com', firstname: 'Josh', lastname: 'Smith', phone: nil, zip: '94109' },
      { email: 'johns@home.com', firstname: 'Jon', lastname: 'Smithery', phone: '(555) 123-4567', zip: '94105' },
      { email: '', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
      { email: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
    ]
  }
  subject { described_class.call(data) }

  describe '#call' do
    context ('group by email (the default)') do
      it 'should return an array of hashes with id prepended to all hashes, having the same id for the same emails' do
        expect(subject).to eq([
            { id: 1, email: '', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', zip: '94105' },
            { id: 2, email: 'charlesch@gmail.com', firstname: 'Charles', lastname: 'Chou', phone: '(858) 888-8888', zip: '92064' },
            { id: 3, email: 'joshs@home.com', firstname: 'Josh', lastname: 'Smith', phone: nil, zip: '94109' },
            { id: 4, email: 'johns@home.com', firstname: 'Jon', lastname: 'Smithery', phone: '(555) 123-4567', zip: '94105' },
            { id: 5, email: '', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
            { id: 4, email: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
          ])
      end

      context 'multiple emails per record' do
        let(:data) {
          [
            { email1: '', email2: 'johns3@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', zip: '94105' },
            { email1: 'charlesch@gmail.com', email2: 'charlesch2@gmail.com', firstname: 'Charles', lastname: 'Chou', phone: '(858) 888-8888', zip: '92064' },
            { email1: 'joshs@home.com', email2: 'joshs2@home.com', firstname: 'Josh', lastname: 'Smith', phone: nil, zip: '94109' },
            { email1: 'johns@home.com', email2: '', firstname: 'Jon', lastname: 'Smithery', phone: '(555) 123-4567', zip: '94105' },
            { email1: '', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
            { email1: 'johns5@home.com', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
          ]
        }

        it 'should return an array of hashes with id prepended to all hashes, having the same id for the same emails' do
          expect(subject).to eq([
            { id: 1, email1: '', email2: 'johns3@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', zip: '94105' },
            { id: 2, email1: 'charlesch@gmail.com', email2: 'charlesch2@gmail.com', firstname: 'Charles', lastname: 'Chou', phone: '(858) 888-8888', zip: '92064' },
            { id: 3, email1: 'joshs@home.com', email2: 'joshs2@home.com', firstname: 'Josh', lastname: 'Smith', phone: nil, zip: '94109' },
            { id: 4, email1: 'johns@home.com', email2: '', firstname: 'Jon', lastname: 'Smithery', phone: '(555) 123-4567', zip: '94105' },
            { id: 4, email1: '', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
            { id: 4, email1: 'johns5@home.com', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
          ])
        end
      end
    end

    context 'group by phone' do
      subject { described_class.call(data, :phone) }

      it 'should return an array of hashes with id prepended to all hashes, having the same id for the same emails' do
        expect(subject).to eq([
            { id: 1, email: '', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', zip: '94105' },
            { id: 2, email: 'charlesch@gmail.com', firstname: 'Charles', lastname: 'Chou', phone: '(858) 888-8888', zip: '92064' },
            { id: 3, email: 'joshs@home.com', firstname: 'Josh', lastname: 'Smith', phone: nil, zip: '94109' },
            { id: 1, email: 'johns@home.com', firstname: 'Jon', lastname: 'Smithery', phone: '(555) 123-4567', zip: '94105' },
            { id: 4, email: '', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
            { id: 4, email: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone: '(555) 867-5309', zip: '12345' },
          ])
      end
    end
  end
end
