RSpec.describe Book, type: :model do

  context 'associations' do
    it { should have_many(:transactions) }
  end

  context 'schema' do
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'validations' do
    subject { build(:book) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:created_at) }
    it { should_not validate_presence_of(:updated_at) }
    it { should be_valid }
  end

end
