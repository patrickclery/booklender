RSpec.describe User, type: :model do

  it { should have_db_column(:account_number).of_type(:string).with_options(null: false) } # Allow alphanumeric
  it { should have_db_column(:name).of_type(:string).with_options(null: false) }
  it { should have_db_column(:balance_cents).of_type(:integer).with_options(null: false).present }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  context 'validations' do
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:name) }

    it { should monetize(:balance).presence }
  end

end
