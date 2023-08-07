require 'rails_helper'

RSpec.describe User, type: :model do
  # Предполагаем, что у вас есть фабрика для создания пользователей (user)
  let(:user) { create(:user) }

  it { should have_many(:wishlists).dependent(:destroy) }
  it { should have_many(:administration_boxes).class_name('Box').with_foreign_key('admin_id') }
  it { should have_and_belong_to_many(:participated_boxes).class_name('Box') }

  it 'has valid SEXES constants' do
    expect(User::SEXES).to eq({ male: 0, female: 1, unknown: 2 })
  end

  describe '#sex_name' do
    it 'returns "male" when sex is 0' do
      user.update(sex: 0)
      expect(user.sex_name).to eq(:male)
    end

    it 'returns "female" when sex is 1' do
      user.update(sex: 1)
      expect(user.sex_name).to eq(:female)
    end

    it 'returns "unknown" when sex is 2' do
      user.update(sex: 2)
      expect(user.sex_name).to eq(:unknown)
    end
  end

  it 'is not valid without an email' do
    user = User.new(password: 'password')
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is valid with a valid email and password' do
    user = User.new(email: 'test@example.com', password: 'password')
    expect(user).to be_valid
  end
end
