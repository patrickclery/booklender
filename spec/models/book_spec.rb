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
    subject { Book.new(title:  "Rework",
                       author: "David Heinemeier Hansson and Jason Fried") }

    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:title) }
    it { should be_valid }
  end

end
