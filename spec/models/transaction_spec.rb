RSpec.describe Transaction, type: :model do

  describe 'associations' do
    it { should belong_to(:user).required(true) }
    it { should belong_to(:book).required(true) }
  end

  describe 'schema' do
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) } # Allow alphanumeric
    it { should have_db_column(:book_id).of_type(:integer).with_options(null: false) } # Allow alphanumeric
    it { should have_db_column(:amount_cents).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:returned_at).of_type(:datetime) }
  end

  context 'validations' do

    let!(:user) { create(:user) }
    let!(:book) { create(:book) }

    subject { Transaction.new(user: user, book: book) } # Using the real class here because factory_bot behaves differently with stubbing class constants

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:book) }
    it { should_not validate_presence_of(:returned_at) }
    it { should allow_value(1.week.ago).for(:returned_at) }
    it { should allow_value(99).for(:amount_cents).presence }
    it { should monetize(:amount_cents).presence }
    it 'should use the default rental fee' do
      stub_const("Transaction::RENTAL_FEE", 555)
      should have_attributes(amount_cents: 555)
    end
    it { should be_valid }
  end
end
