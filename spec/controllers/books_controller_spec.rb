RSpec.describe BooksController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Book. As you add validations to Book, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title:  "Rework",
      author: "David Heinemeier Hansson and Jason Fried"
    }
  end

  let(:invalid_attributes) do
    {
      title:  nil,
      author: nil
    }
  end
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BooksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    # Note, semantics here are important: before must come before "subject!"
    before do
      allow(Book).to receive(:extended_details).and_return(book_stack)
    end

    subject! { get :index, session: valid_session }

    # Create a list of 12 books and stub the extended details using ":stub_copies" trait
    let!(:book_stack) { create_list(:book, 12, :stub_copies) }

    it { should be_successful }
    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(JSON.parse(response.body)).to be_an Array }
    it { expect(JSON.parse(response.body).first.keys).to include("id", "title", "author", "created_at", "total_income_cents", "copies_count", "remaining_copies_count", "loaned_copies_count") }
    it { expect(JSON.parse(response.body).size).to eq 12 }
  end

  describe "GET #show" do
    # Note, semantics here are important: before must come before "subject!"
    before do
      allow_any_instance_of(Book).to receive(:extended_details).and_return(book)
    end

    subject! { get :show, params: { id: book.to_param }, session: valid_session }

    # Create 2 transaction with a total of 50 cents
    let!(:book) { create(:book, :stub_copies) }

    it { should have_http_status(:success) }
    it { expect(JSON.parse(response.body).keys).to include("id", "title", "author", "created_at", "total_income_cents", "copies_count", "remaining_copies_count", "loaned_copies_count") }
    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(JSON.parse(response.body)).to be_a Hash }
    it { expect(JSON.parse(response.body).keys).to include("id", "title", "author", "created_at", "total_income_cents", "copies_count", "remaining_copies_count", "loaned_copies_count") }
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
          title:  "Think & Grow Skillz",
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
