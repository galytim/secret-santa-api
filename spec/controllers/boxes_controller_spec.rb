# spec/controllers/boxes_controller_spec.rb
require 'rails_helper'

RSpec.describe BoxesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user) }
  let(:box) { create(:box, admin: admin) }
  let(:participant) { create(:user) }

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

  # Добавьте другие тесты для других методов контроллера
end
