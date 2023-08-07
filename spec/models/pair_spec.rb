require 'rails_helper'

RSpec.describe Pair, type: :model do
  # Предполагаем, что у вас есть фабрики для создания пользователей (user) и коробок (box)
  let(:giver) { create(:user) }
  let(:recipient) { create(:user) }
  let(:box) { create(:box) }

  it { should belong_to(:giver).class_name('User').with_foreign_key('giver_id') }
  it { should belong_to(:recipient).class_name('User').with_foreign_key('recipient_id') }
  it { should belong_to(:box) }

  it { should validate_presence_of(:giver_id) }
  it { should validate_presence_of(:recipient_id) }
  it { should validate_presence_of(:box_id) }

  it 'is valid with valid attributes' do
    pair = Pair.new(giver: giver, recipient: recipient, box: box)
    expect(pair).to be_valid
  end

  it 'is not valid without a giver' do
    pair = Pair.new(recipient: recipient, box: box)
    expect(pair).not_to be_valid
    expect(pair.errors[:giver_id]).to include("can't be blank")
  end

  it 'is not valid without a recipient' do
    pair = Pair.new(giver: giver, box: box)
    expect(pair).not_to be_valid
    expect(pair.errors[:recipient_id]).to include("can't be blank")
  end

  it 'is not valid without a box' do
    pair = Pair.new(giver: giver, recipient: recipient)
    expect(pair).not_to be_valid
    expect(pair.errors[:box_id]).to include("can't be blank")
  end
end
