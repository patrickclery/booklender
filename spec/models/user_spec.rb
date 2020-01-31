RSpec.describe User, type: :model do

  context 'associations' do
    it { should have_many(:transactions) }
    it { should have_many(:books).through(:transactions).order('transactions.created_at').source(:book) }
    it { should have_many(:returned_books).through(:transactions).conditions('transactions.returned_at IS NOT NULL').order('transactions.returned_at').source(:book) }
    it { should have_many(:loaned_books).through(:transactions).conditions('transactions.returned_at IS NULL').order('transactions.created_at').source(:book) }
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

  describe ".loaned_books_count" do
    # Note, semantics here are important: before must come before "subject!"
    before do
      allow_any_instance_of(User).to receive(:loaned_books).and_return(loaned_books)
    end

    subject { user.loaned_books_count }
    let!(:loaned_books) { create_list(:book, 4) }
    let!(:user) { create(:user) }

    it { expect(user).to respond_to(:loaned_books_count) }
    it { should eq 4 }
  end

  describe ".returned_books_count" do
    # Note, semantics here are important: before must come before "subject!"
    before do
      allow_any_instance_of(User).to receive(:returned_books).and_return(returned_books)
    end

    subject { user.returned_books_count }
    let!(:returned_books) { create_list(:book, 4) }
    let!(:user) { create(:user) }

    it { expect(user).to respond_to(:returned_books_count) }
    it { should eq 4 }
  end

end
