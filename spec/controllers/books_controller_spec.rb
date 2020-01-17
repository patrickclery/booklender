RSpec.describe BooksController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Book. As you add validations to Book, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title: "Rework",
      author: "David Heinemeier Hansson and Jason Fried"
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      author: nil
    }
  end
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BooksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      book = Book.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      book = Book.create! valid_attributes
      get :show, params: { id: book.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Book" do
        expect {
          post :create, params: { book: valid_attributes }, session: valid_session
        }.to change(Book, :count).by(1)
      end

      it "renders a JSON response with the new book" do

        post :create, params: { book: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.location).to eq(book_url(Book.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new book" do

        post :create, params: { book: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          title: "Think & Grow Skillz",
          author: "Napoleon Dynamite"
        }
      }

      it "updates the requested book" do
        book = Book.create! valid_attributes
        put :update, params: { id: book.to_param, book: new_attributes }, session: valid_session
        book.reload
      end

      it "renders a JSON response with the book" do
        book = Book.create! valid_attributes

        put :update, params: { id: book.to_param, book: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the book" do
        book = Book.create! valid_attributes

        put :update, params: { id: book.to_param, book: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested book" do
      book = Book.create! valid_attributes
      expect {
        delete :destroy, params: { id: book.to_param }, session: valid_session
      }.to change(Book, :count).by(-1)
    end
  end

end
