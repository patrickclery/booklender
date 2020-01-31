RSpec.describe UsersController, type: :controller do

  let(:valid_attributes) do
    {
      name:           "Jim Shorts",
      balance_cents:  5000,
      account_number: '0X5'
    }
  end

  let(:invalid_attributes) do
    {
      name:           nil,
      balance_cents:  -10,
      account_number: nil
    }
  end
  let(:valid_session) { {} }

  describe "GET #index" do
    # Note, semantics here are important: before must come before "subject!"
    before do
      allow(User).to receive(:extended_details).and_return(users)
    end

    subject! { get :index, session: valid_session }

    # Create a list of 12 books and stub the extended details using ":stub_copies" trait
    let(:users) { create_list(:user, 3) }

    it { expect(subject).to have_http_status(:success) }
    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(JSON.parse(response.body)).to be_an Array }
    it { expect(JSON.parse(response.body).first.keys).to include("id", "account_number", "name", "balance_cents", "created_at", "loaned_books_count", "returned_books_count") }
    it { expect(JSON.parse(response.body).size).to eq 3 }
  end

  describe "GET #show" do
    # Note, semantics here are important: before must come before "subject!"
    before do
      allow_any_instance_of(User).to receive(:returned_books).and_return(returned_books)
      allow_any_instance_of(User).to receive(:loaned_books).and_return(loaned_books)
      allow_any_instance_of(User).to receive(:books).and_return(books)
      allow(User).to receive(:find).and_return(user)
    end

    subject! { get :show, params: { id: user.to_param }, session: valid_session }

    let!(:loaned_books) { build_stubbed_list(:book, 4) }
    let!(:returned_books) { build_stubbed_list(:book, 5) }
    let!(:books) { loaned_books + returned_books }
    let!(:user) { build_stubbed(:user) }

    it { should have_http_status(:success) }
    it { expect(JSON.parse(response.body).keys).to include("id", "account_number", "name", "balance_cents", "created_at", "loaned_books", "returned_books") }
    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(JSON.parse(response.body)).to be_a Hash }
    it { expect(JSON.parse(response.body).keys).to include("id", "account_number", "name", "balance_cents", "created_at", "loaned_books", "returned_books") }
    it { expect(JSON.parse(response.body).keys).to include("id", "account_number", "name", "balance_cents", "created_at", "loaned_books", "returned_books") }
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }, session: valid_session
        }.to change(User, :count).by(1)
      end

       it "renders a JSON response with the new user" do

        post :create, params: { user: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.location).to eq(user_url(User.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new user" do

        post :create, params: { user: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          name:           "Ron A. Muck",
          balance_cents:  7000,
          account_number: '0A9'
        }
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }, session: valid_session
        user.reload
      end

      it "renders a JSON response with the user" do
        user = User.create! valid_attributes

        put :update, params: { id: user.to_param, user: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the user" do
        user = User.create! valid_attributes

        put :update, params: { id: user.to_param, user: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, params: { id: user.to_param }, session: valid_session
      }.to change(User, :count).by(-1)
    end
  end

end
