RSpec.describe Book, type: :model do

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
    subject { build(:book) }

    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:title) }
    it { should be_valid }
  end

  describe '.total_copies' do
    subject { book.extended_details.copies_count }
    let!(:book_stack) { create_list(:book, 12, title: "How to Cook Stuff", author: "Chef Joe") }
    let!(:book) { book_stack.first }

    it { expect(book).to respond_to(:copies_count).with(0).arguments }
    it { should eq 12 }
  end

  describe '.remaining_copies_count' do
    subject { book.extended_details.remaining_copies_count }
    let!(:book_stack) { create_list(:book, 12, title: "How to Cook Stuff", author: "Chef Joe") }
    let!(:user) { create(:user) }
    let!(:book) { book_stack.first }

    # Create loans for 3 copies
    let!(:transactions) do
      1.upto(3) do |i|
        create(:transaction, book: book_stack[i-1], user: user)
      end
      # Make an arbitrary amount of returned transactions (they should not interfere)
      4.upto(7) do |i|
        create(:transaction, :returned, book: book_stack[i-1], user: user)
      end
    end

    it { expect(book).to respond_to(:extended_details, :remaining_copies_count).with(0).arguments }
    it { should eq 9 } # 12 copies - 9 copies = 3
  end

  describe '.total_income_count' do

    subject { book }

    # Create 2 transaction with a total of 50 cents
    let!(:user) { create(:user) }
    let!(:book) { create(:book) }
    let!(:transaction1) { create(:transaction, user: user, book: book, amount_cents: 25, created_at: DateTime.new(2020, 1, 3)) }
    let!(:transaction2) { create(:transaction, user: user, book: book, amount_cents: 25, created_at: DateTime.new(2020, 1, 6)) }

    # Make one date cover the range, the other outside the range
    let!(:start_date1) { DateTime.new(2020, 1, 2) }
    let!(:end_date1) { DateTime.new(2020, 1, 4) }
    let!(:start_date2) { DateTime.new(2020, 1, 1) }
    let!(:end_date2) { DateTime.new(2020, 1, 2) }

    it { should respond_to(:extended_details, :total_income_cents) }
    it { expect(subject.extended_details(from: start_date1, to: end_date1).total_income_cents).to be 25 }
    it { expect(subject.extended_details(from: start_date2, to: end_date2).total_income_cents).to be 0 }
    it { expect(subject.extended_details.total_income_cents).to be 50 }

  end

  # This will test out a stack of books that have transactions across 2 users
  describe '#extended_details' do

    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    let!(:book_stack) { create_list(:book, 12) } # 9/12 books never rented
    let!(:book1) { book_stack.first } # 1 active loan
    let!(:book2) { book_stack.second } # 1 active loan
    let!(:book3) { book_stack.third } # 1 return

    # There should be 2 loaned, 1 returned, 9 never rented
    let!(:book_rental_transaction1) { create(:transaction, user: user1, book: book1, amount_cents: 25, created_at: DateTime.new(2020, 1, 1)) }
    let!(:book_rental_transaction2) { create(:transaction, user: user2, book: book2, amount_cents: 25, created_at: DateTime.new(2020, 1, 3)) }
    let!(:book_rental_transaction3) { create(:transaction, :returned, user: user2, book: book3, amount_cents: 25, created_at: DateTime.new(2020, 1, 5)) }

    context "with no date range provided" do
      subject { Book.extended_details }

      it { expect(Book).to respond_to(:extended_details).with(0).arguments }
      it { expect(Book).to respond_to(:extended_details).with_keywords(:title, :author) }
      it { expect(subject).to contain_exactly(*book_stack) }
      it { expect(subject.sample.attributes.keys).to contain_exactly("id", "title", "author", "copies_count", "loaned_copies_count", "remaining_copies_count", "total_income_cents", "created_at") }
      # Check that each book has the correct income
      it { expect(subject.detect { |book| book == book1 }).to have_attributes(total_income_cents: 25) }
      it { expect(subject.detect { |book| book == book2 }).to have_attributes(total_income_cents: 25) }
      it { expect(subject.detect { |book| book == book3 }).to have_attributes(total_income_cents: 25) }
    end

    context "when provided a date range" do
      subject { Book.extended_details(from: start_date, to: end_date) }

      let!(:start_date) { DateTime.new(2020, 1, 2) } # One day after the first transaction
      let!(:end_date) { DateTime.new(2020, 1, 6) } # One day after the last transaction

      it { expect(Book).to respond_to(:extended_details).with_keywords(:from, :to, :title, :author) }
      it { expect(subject).to contain_exactly(*book_stack) }
      it { expect(subject.sample.attributes.keys).to contain_exactly("id", "title", "author", "copies_count", "loaned_copies_count", "remaining_copies_count", "total_income_cents", "created_at") }
      # Check that each book has the correct income
      it { expect(subject.detect { |book| book == book1 }).to have_attributes(total_income_cents: 0) }
      it { expect(subject.detect { |book| book == book2 }).to have_attributes(total_income_cents: 25) }
      it { expect(subject.detect { |book| book == book3 }).to have_attributes(total_income_cents: 25) }
    end
  end

end
