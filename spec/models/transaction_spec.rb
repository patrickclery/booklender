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

    let!(:user) { build_stubbed(:user) }
    let!(:book) { build_stubbed(:book) }

    subject { build(:transaction, user: user, book: book) }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:book) }
    it { should validate_presence_of(:created_at) }
    it { should_not validate_presence_of(:returned_at) }
    it { should allow_value(1.week.ago).for(:returned_at) }
    it { should monetize(:amount_cents).presence }
    it { should be_valid }

  end

end
