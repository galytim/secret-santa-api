require 'rails_helper'

RSpec.describe BoxesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin) { create(:user) }
  let!(:box) { create(:box, admin: admin) }
  let!(:participant) { create(:user) }

  describe 'GET #index' do
    it 'returns a successful response' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      sign_in user
      get :show, params: { id: box.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the correct box' do
      sign_in user
      get :show, params: { id: box.id }
      expect(assigns(:box)).to eq(box)
    end

    it 'returns the correct JSON data' do
        # Подписываем пользователя с атрибутом admin: true
        sign_in admin
  
        # Вызываем метод show контроллера BoxesController с параметром id
        get :show, params: { id: box.id }
  
        # Проверяем успешный HTTP-ответ
        expect(response).to have_http_status(:success)
  
        # Парсим JSON-ответ
        json_response = JSON.parse(response.body)
  
        # Ожидаемые данные для сравнения
        expected_data = {
            "box" => {
              "id" => box.id,
              "nameBox" => box.nameBox,
              "dateFrom" => box.dateFrom.strftime('%Y-%m-%d'), # Преобразуйте дату в строку
              "dateTo" => box.dateTo.strftime('%Y-%m-%d'), # Преобразуйте дату в строку
              "priceFrom" => box.priceFrom,
              "priceTo" => box.priceTo,
              "place" => box.place,
              "admin_id" => box.admin_id,
              "description" => box.description
            },
            "participants" => box.participants.map { |participant| participant.attributes.slice('id', 'name', 'email') },
            "current_user_admin" => true, # Предполагаем, что администратор вошел в систему и это значение будет true
            "recipient" => { "email" => nil, "id" => nil, "name" => nil }
          }
          
        # Сравниваем только нужные данные
        expect(json_response).to eq(expected_data)
      end
      

    it 'returns the correct recipient for giver' do
      sign_in participant
      box.participants << participant
      pair = create(:pair, giver: participant, recipient: admin, box: box)
      get :show, params: { id: box.id }
      expect(JSON.parse(response.body)['recipient']).to eq({
        'id' => admin.id,
        'name' => admin.name,
        'email' => admin.email
      })
    end
  end

  describe 'POST #create' do
    it 'creates a new box' do
      sign_in admin
      expect {
        post :create, params: { box: attributes_for(:box) }
      }.to change(Box, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH #update' do
    it 'updates box attributes' do
      sign_in admin
      new_name = 'Updated Box Name'
      patch :update, params: { id: box.id, box: { nameBox: new_name } }
      expect(response).to have_http_status(:success)
      expect(box.reload.nameBox).to eq(new_name)
    end
  end

  describe 'DELETE #destroy' do
    it 'updates admin when removing admin participant' do
      admin_user = User.create(name: 'Admin User', email: 'admin@example.com', password: 'password')
      box = Box.create(nameBox: 'Test Box', admin: admin_user)
    
      sign_in admin_user
    
      expect {
        delete :remove_participant, params: { id: box.id, user_id: admin_user.id }
      }.to change(Box, :count).by(-1)
    
      expect(response).to have_http_status(:no_content)
    end
    

    it 'returns error when non-admin tries to remove participant' do
      admin_user = User.create(name: 'Admin User', email: 'admin@example.com', password: 'password')
      participant_user = User.create(name: 'Participant User', email: 'participant@example.com', password: 'password')
      box = Box.create(nameBox: 'Test Box', admin: admin_user, participants: [admin_user, participant_user])
    
      sign_in participant_user
    
      expect {
        delete :remove_participant, params: { id: box.id, user_id: admin_user.id }
      }.not_to change(box.participants, :count)
    
      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)['error']).to eq("You don't have permission to remove this user from participants.")
    end
    
    it 'returns error when non-admin tries to remove self' do
      user = User.create(name: 'Test User', email: 'user@example.com', password: 'password')
      box = Box.create(nameBox: 'Test Box', admin: user, participants: [user])
    
      sign_in user
    
      expect {
        delete :remove_participant, params: { id: box.id, user_id: user.id }
      }.to change(box.participants, :count).by(-1)
    
      expect(response).to have_http_status(:no_content)
    end
    
  end

  describe 'POST #add_participant' do
    it 'adds a participant to the box' do

      sign_in admin
      new_participant = create(:user)
      expect {
        post :add_participant, params: { id: box.id, email: new_participant.email }
      }.to change(box.participants, :count).by(1)
      expect(response).to have_http_status(:ok)
    end

  end
  

  describe 'GET #start' do
    it 'starts the draw and creates pairs' do
      sign_in admin
      expect {
        get :start, params: { id: box.id }
      }.to change(Pair, :count).by(box.participants.count)
      expect(response).to have_http_status(:ok)
    end
  end
end
