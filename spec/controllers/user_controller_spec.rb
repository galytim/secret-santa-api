# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'GET #show' do
    it 'returns user data' do
      sign_in user
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(user_json(user))
    end

    it 'returns user data for current user' do
      sign_in user
      get :show, params: { id: other_user.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(user_json(other_user))
    end

    it 'returns unauthorized if not logged in' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH #update' do
    it 'updates user data for current user' do
      sign_in user
      new_name = 'New Name'
      patch :update, params: { id: user.id, user: { name: new_name } }
      expect(response).to have_http_status(:success)
      user.reload
      expect(user.name).to eq(new_name)
    end

    it 'returns unauthorized if updating other user data' do
      sign_in user
      patch :update, params: { id: other_user.id, user: { name: 'New Name' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes user for current user' do
      sign_in user
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:no_content)
      expect(User.exists?(user.id)).to be_falsey
    end

    it 'returns unauthorized if deleting other user' do
      sign_in user
      delete :destroy, params: { id: other_user.id }
      expect(response).to have_http_status(:unauthorized)
      expect(User.exists?(other_user.id)).to be_truthy
    end
  end

  # Метод для возврата хеша с данными пользователя
  def user_json(user)
    user_attributes = user.slice(:id, :email,:name, :sex)

    user_attributes[:dateOfBirth] = user.dateOfBirth.strftime('%Y-%m-%d') if user.dateOfBirth.present?
    user_attributes[:phone] = user.phone if user.phone.present?

    user_attributes
  end
end
