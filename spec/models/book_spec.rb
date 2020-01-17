RSpec.describe Book, type: :model do

  subject { Book.new(title: "Rework", author: "David Heinemeier Hansson and Jason Fried") }

  let!(:book_with_copies) { create_list(:book, 12, title: "The Outsider", author: "Albert Camus") }

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
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:title) }
    it { should be_valid }
  end

  describe '#total_copies' do
    subject { described_class }
    it { should respond_to(:total_copies).with_keywords(:title, :author) }
    it { expect(subject.total_copies(title: "The Outsider", author: "Albert Camus")).to eq 12 }
  end

  describe '.total_copies' do
    subject { build(:book, title: "The Outsider", author: "Albert Camus") }
    it { should respond_to(:total_copies) }
    it { expect(subject.total_copies).to eq 12 }
  end

end
