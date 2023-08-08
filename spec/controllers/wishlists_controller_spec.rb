require 'rails_helper'

RSpec.describe WishlistsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:wishlist) { FactoryBot.create(:wishlist, user: user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    it 'returns a list of wishlists for a given user' do
        sign_in user
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:success)
  
        wishlists_json = user.wishlists.map { |wishlist| wishlist.slice(:id, :description, :user_id) }
        expect(JSON.parse(response.body)).to eq(wishlists_json)
      end
      
    it 'returns unauthorized if not logged in' do
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #show' do
    it 'returns the wishlist data' do
      sign_in user
      get :show, params: { user_id: user.id, id: wishlist.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(wishlist_json(wishlist))
    end

    it 'returns not found for non-existing wishlist' do
      sign_in user
      get :show, params: { user_id: user.id, id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    it 'creates a new wishlist for current user' do
      sign_in user
      wishlist_params = { description: 'My Wishlist' }
      expect {
        post :create, params: { user_id: user.id, wishlist: wishlist_params }
      }.to change(Wishlist, :count).by(1)
      expect(response).to have_http_status(:created)
      new_wishlist = Wishlist.last
      expect(new_wishlist.user).to eq(user)
      expect(JSON.parse(response.body)).to eq(wishlist_json(new_wishlist))
    end

    it 'returns unauthorized if not logged in' do
      post :create, params: { user_id: user.id, wishlist: { description: 'My Wishlist' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH #update' do
    it 'updates wishlist data for current user' do
      sign_in user
      new_description = 'Updated Wishlist'
      patch :update, params: { user_id: user.id, id: wishlist.id, wishlist: { description: new_description } }
      expect(response).to have_http_status(:success)
      wishlist.reload
      expect(wishlist.description).to eq(new_description)
    end

    it 'returns unauthorized if not the owner of the wishlist' do
      sign_in other_user
      new_description = 'Updated Wishlist'
      patch :update, params: { user_id: user.id, id: wishlist.id, wishlist: { description: new_description } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns not found for non-existing wishlist' do
      sign_in user
      new_description = 'Updated Wishlist'
      patch :update, params: { user_id: user.id, id: 999, wishlist: { description: new_description } }
      expect(response).to have_http_status(:not_found)
    end
  end
  describe 'DELETE #destroy' do 
    it 'deletes wishlist for current user' do
      user = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      wishlist = Wishlist.create(description: 'Test Wishlist', user: user)
      
      sign_in user
      
      expect {
        delete :destroy, params: { user_id: user.id, id: wishlist.id }
      }.to change(Wishlist, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
    
    it 'returns unauthorized if not the owner of the wishlist' do
      user = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      other_user = User.create(name: 'Other User', email: 'other@example.com', password: 'password')
      wishlist = Wishlist.create(description: 'Test Wishlist', user: user)
      
      sign_in other_user
      
      delete :destroy, params: { user_id: user.id, id: wishlist.id }
      expect(response).to have_http_status(:unauthorized)
    end
  
    it 'returns not found for non-existing wishlist' do
      user = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      
      sign_in user
      
      delete :destroy, params: { user_id: user.id, id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
  

  # Метод для возврата хеша с данными вишлиста
  def wishlist_json(wishlist)
    wishlist_attributes = wishlist.slice(:id, :description, :user_id)
    wishlist_attributes[:user_id] = wishlist.user_id
    wishlist_attributes
  end
end
