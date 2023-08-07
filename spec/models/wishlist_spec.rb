require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  # Предполагаем, что у вас есть фабрика для создания пользователей (user)
  let(:user) { create(:user) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:description) }

  it 'is valid with a user and description' do
    wishlist = Wishlist.new(user: user, description: 'Sample description')
    expect(wishlist).to be_valid
  end

  it 'is not valid without a description' do
    wishlist = Wishlist.new(user: user)
    expect(wishlist).not_to be_valid
    expect(wishlist.errors[:description]).to include("can't be blank")
  end
end
