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

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  # Create 12 books total
  let!(:book_stack) { create_list(:book, 12, title: "The Outsider", author: "Albert Camus") }

  # There should be 2 loaned, 1 returned, 9 never rented
  let!(:book_rental_transaction1) { create(:transaction, user: user1, book: book_stack.first, amount_cents: 25, created_at: DateTime.new(2020, 1, 1)) }
  let!(:book_rental_transaction2) { create(:transaction, user: user2, book: book_stack.second, amount_cents: 25, created_at: DateTime.new(2020, 1, 3)) }
  let!(:book_rental_transaction3) { create(:transaction, :returned, user: user2, book: book_stack.third, amount_cents: 25, created_at: DateTime.new(2020, 1, 5)) }

  describe "GET #index" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #loans" do

    let!(:loaned_books) { create_list(:book, 5) }
    let!(:user_with_books) { create(:user) }
    let!(:user_attributes) { [:id, :name, :created_at, :account_number, ] }

    subject! do
      allow(User).to receive(:find).and_return(user_with_books)
      allow_any_instance_of(User).to receive(:loaned_books).and_return(loaned_books)
      get :loaned_books, params: { id: user1.to_param }, session: valid_session
    end

    it { should have_http_status(:success) }
    # call .as_json on the loaned_books since the timestamp will be slightly different
    it { expect(JSON.parse(response.body).dig("loaned_books")).to eq loaned_books.map(&:as_json) }
    it { expect(JSON.parse(response.body).keys).to include("id", "name", "account_number", "balance_cents")  }
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
