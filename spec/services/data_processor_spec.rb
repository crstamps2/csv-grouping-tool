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
      context 'multiple phone numbers per record' do
        let(:data) {
          [
            { email1: '', email2: 'johns3@home.com', firstname: 'John', lastname: 'Smith', phone1: '(555) 123-4567', phone2: '(555) 867-5309', zip: '94105' },
            { email1: 'charlesch@gmail.com', email2: 'charlesch2@gmail.com', firstname: 'Charles', lastname: 'Chou', phone1: '(858) 888-8888', phone2: '(858) 888-9999', zip: '92064' },
            { email1: 'joshs@home.com', email2: 'joshs2@home.com', firstname: 'Josh', lastname: 'Smith', phone1: nil, phone2: '(555) 867-5309', zip: '94109' },
            { email1: 'johns@home.com', email2: '', firstname: 'Jon', lastname: 'Smithery', phone1: '(555) 765-4321', phone2: '', zip: '94105' },
            { email1: '', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone1: '(555) 867-5309', phone2: '(555) 765-4321', zip: '12345' },
            { email1: 'johns5@home.com', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone1: '(555) 444-4444', phone2: '(555) 777-7777', zip: '12345' },
          ]
        }

        it 'should return an array of hashes with id prepended to all hashes, having the same id for the same emails' do
          expect(subject).to eq([
            { id: 1, email1: '', email2: 'johns3@home.com', firstname: 'John', lastname: 'Smith', phone1: '(555) 123-4567', phone2: '(555) 867-5309', zip: '94105' },
            { id: 2, email1: 'charlesch@gmail.com', email2: 'charlesch2@gmail.com', firstname: 'Charles', lastname: 'Chou', phone1: '(858) 888-8888', phone2: '(858) 888-9999', zip: '92064' },
            { id: 1, email1: 'joshs@home.com', email2: 'joshs2@home.com', firstname: 'Josh', lastname: 'Smith', phone1: nil, phone2: '(555) 867-5309', zip: '94109' },
            { id: 3, email1: 'johns@home.com', email2: '', firstname: 'Jon', lastname: 'Smithery', phone1: '(555) 765-4321', phone2: '', zip: '94105' },
            { id: 1, email1: '', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone1: '(555) 867-5309', phone2: '(555) 765-4321', zip: '12345' },
            { id: 4, email1: 'johns5@home.com', email2: 'johns@home.com', firstname: 'John', lastname: 'Smith', phone1: '(555) 444-4444', phone2: '(555) 777-7777', zip: '12345' },
          ])
        end
      end
    end

    context 'group by both email and phone' do
      subject { described_class.call(data, :both) }

      let(:data) do
        [
          { email1: 'johns@home.com', phone1: '(555) 123-4567', firstname: 'John', lastname: 'Smith', zip: '94105' },
          { email1: 'charles@work.com', phone1: '(111) 222-3333', firstname: 'Charles', lastname: 'Chou', zip: '92064' },
          { email1: 'janes@home.com', phone1: '(555) 123-4567', firstname: 'Jane', lastname: 'Smith', zip: '94105' },
          { email1: 'janes@home.com', phone1: '(444) 555-6666', firstname: 'Janet', lastname: 'Smith', zip: '94105' },
          { email1: 'sue@company.com', phone1: '(777) 888-9999', firstname: 'Sue', lastname: 'Smith', zip: '94105' },
          { email1: 'john.smith@work.com', email2: 'johns@home.com', phone1: '(222) 333-4444', firstname: 'Johnny', lastname: 'Smith', zip: '94105' }
        ]
      end

      it 'groups records by shared emails OR phone numbers' do
        expect(subject).to eq([
          { id: 1, email1: 'johns@home.com', phone1: '(555) 123-4567', firstname: 'John', lastname: 'Smith', zip: '94105' },
          { id: 2, email1: 'charles@work.com', phone1: '(111) 222-3333', firstname: 'Charles', lastname: 'Chou', zip: '92064' },
          { id: 1, email1: 'janes@home.com', phone1: '(555) 123-4567', firstname: 'Jane', lastname: 'Smith', zip: '94105' },
          { id: 1, email1: 'janes@home.com', phone1: '(444) 555-6666', firstname: 'Janet', lastname: 'Smith', zip: '94105' },
          { id: 3, email1: 'sue@company.com', phone1: '(777) 888-9999', firstname: 'Sue', lastname: 'Smith', zip: '94105' },
          { id: 1, email1: 'john.smith@work.com', email2: 'johns@home.com', phone1: '(222) 333-4444', firstname: 'Johnny', lastname: 'Smith', zip: '94105' }
        ])
      end
    end
  end
end
