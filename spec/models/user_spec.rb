RSpec.describe User, type: :model do

  context 'associations' do
    it { should have_many(:transactions) }
  end

  context 'schema' do
    it { should have_db_column(:account_number).of_type(:string).with_options(null: false) } # Allow a padded number or alphanumeric
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'validations' do
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:created_at) }
    it { should_not validate_presence_of(:updated_at) }
  end

end
