RSpec.describe Book, type: :model do

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  context 'associations' do
    it { should have_many(:transactions) }
  end

  context 'schema' do
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
    it { should have_db_column(:author).of_type(:string).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: true) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: true) }
  end

  context 'validations' do
    subject { Book.new(title: "Rework", author: "David Heinemeier Hansson and Jason Fried") }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:title) }
    it { should be_valid }
  end

  describe '#total_copies' do
    subject { Book }
    let!(:book_stack) { create_list(:book, 12, title: "The Outsider", author: "Albert Camus") }
    it { should respond_to(:total_copies).with_keywords(:title, :author) }
    it { expect(Book.total_copies(title: "The Outsider", author: "Albert Camus")).to eq 12 }
  end

  describe '.total_copies' do
    subject { build(:book, title: "The Outsider", author: "Albert Camus") }
    let!(:book_stack) { create_list(:book, 12, title: "The Outsider", author: "Albert Camus") }
    it { should respond_to(:total_copies) }
    it { expect(subject.total_copies).to eq 12 }
  end

  describe '#remaining_copies' do
    subject { Book }
    it { should respond_to(:remaining_copies).with_keywords(:title, :author) }
    it { expect(Book.remaining_copies(title: "The Outsider", author: "Albert Camus")).to eq 10 }
  end

  describe '.remaining_copies' do
    subject { build(:book, title: "The Outsider", author: "Albert Camus") }
    it { should respond_to(:remaining_copies) }
    it { expect(subject.remaining_copies).to eq 10 }
  end

  describe '#total_income' do
    subject { Book }

    let!(:start_date) { DateTime.new(2020, 1, 2) }
    let!(:end_date) { DateTime.new(2020, 1, 6) }

    it { should respond_to(:total_income).with_keywords(:title, :author, :from, :to) }
    it { expect(Book.total_income(title: "The Outsider", author: "Albert Camus", from: start_date, to: end_date)).to eq 50 }
  end

  describe '.total_income' do
    subject { book1.total_income(from: start_date, to: end_date) }
    let!(:start_date) { DateTime.new(2020, 1, 2) }
    let!(:end_date) { DateTime.new(2020, 1, 6) }
    let!(:book_stack) { create_list(:book, 12) }
    let!(:book1) { book_stack.first }
    let!(:book2) { book_stack.second }
    let!(:book3) { book_stack.third }

    # There should be 2 loaned, 1 returned, 9 never rented
    let!(:book_rental_transaction1) { create(:transaction, user: user1, book: book1, amount_cents: 25, created_at: DateTime.new(2020, 1, 1)) }
    let!(:book_rental_transaction2) { create(:transaction, user: user2, book: book2, amount_cents: 25, created_at: DateTime.new(2020, 1, 3)) }
    let!(:book_rental_transaction3) { create(:transaction, :returned, user: user2, book: book3, amount_cents: 25, created_at: DateTime.new(2020, 1, 5)) }

    it { expect(book1).to respond_to(:total_income).with_keywords(:from, :to) }
    it { should eq 50 }
  end

  describe '#find_detailed_list' do
    subject { Book.find_detailed_list(from: start_date, to: end_date) }

    let!(:start_date) { DateTime.new(2020, 1, 2) }
    let!(:end_date) { DateTime.new(2020, 1, 6) }
    let!(:book_stack) { create_list(:book, 12) }
    let!(:book1) { book_stack.first }
    let!(:book2) { book_stack.second }
    let!(:book3) { book_stack.third }

    # There should be 2 loaned, 1 returned, 9 never rented
    let!(:book_rental_transaction1) { create(:transaction, user: user1, book: book1, amount_cents: 25, created_at: DateTime.new(2020, 1, 1)) }
    let!(:book_rental_transaction2) { create(:transaction, user: user2, book: book2, amount_cents: 25, created_at: DateTime.new(2020, 1, 3)) }
    let!(:book_rental_transaction3) { create(:transaction, :returned, user: user2, book: book3, amount_cents: 25, created_at: DateTime.new(2020, 1, 5)) }

    it { expect(Book).to respond_to(:find_detailed_list).with_keywords(:from, :to) }
    it { expect(subject).to contain_exactly(*book_stack) }

    # Check that each book has the correct income
    it { expect(subject.sample.attributes.keys).to contain_exactly("id", "title", "author", "available_copies_count", "loaned_copies_count", "remaining_copies_count", "total_income_cents") }
    it { expect(subject.detect{|book| book == book1}).to have_attributes(total_income_cents: 0)  }
    it { expect(subject.detect{|book| book == book2}).to have_attributes(total_income_cents: 25) }
    it { expect(subject.detect{|book| book == book3}).to have_attributes(total_income_cents: 25) }
  end

end
