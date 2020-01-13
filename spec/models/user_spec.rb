RSpec.describe User, type: :model do

  # Collections
  it { should have_db_column(:account_number).of_type(:string)  } # Allow alphanumeric
  it { should have_db_column(:balance)       .of_type(:integer) }
  it { should have_db_column(:name)          .of_type(:string)  }

  # Timestamps
  it { should have_db_column(:active_at)  .of_type(:datetime) }
  it { should have_db_column(:created_at) .of_type(:datetime) }
  it { should have_db_column(:deleted_at) .of_type(:datetime) }
  it { should have_db_column(:updated_at) .of_type(:datetime) }

end
