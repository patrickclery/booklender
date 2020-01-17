RSpec.describe User, type: :model do

  context 'associations' do
    it { should have_many(:transactions) }
    it { should have_many(:books).through(:transactions).order('transactions.created_at').source(:book) }
    it { should have_many(:returned_books).through(:transactions).conditions('transactions.returned_at IS NOT NULL').order('transactions.returned_at').source(:book) }
    it { should have_many(:loaned_books).through(:transactions).conditions(returned_at: nil).order('transactions.created_at').source(:book) }
  end

  context 'schema' do
    it { should have_db_column(:account_number).of_type(:string).with_options(null: false) } # Allow a padded number or alphanumeric
    it { should have_db_column(:balance_cents).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: true) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: true) }
  end

  context 'validations' do

    subject { User.new(name:           "Pearl E. Gates",
                       account_number: "123 456 789",
                       balance_cents:  789) }

    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:account_number) }
    it { should_not validate_presence_of(:updated_at) }
    it { should monetize(:balance_cents) }
    it { should be_valid }
  end

end
