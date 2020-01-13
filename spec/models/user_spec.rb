RSpec.describe User, type: :model do

  it { should have_db_column(:account_number).of_type(:string).with_options(null: false) } # Allow alphanumeric
  it { should have_db_column(:balance).of_type(:decimal).with_options(null: false, precision: 3, scale: 2) }
  it { should have_db_column(:name).of_type(:string).with_options(null: false) }

  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  context 'validations' do
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:balance).presence }
  end

end
