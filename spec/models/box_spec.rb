require 'rails_helper'

RSpec.describe Box, type: :model do
  # Предполагаем, что у вас есть фабрика для создания пользователей (user)
  let(:admin) { create(:user) }
  let(:participant1) { create(:user) }
  let(:participant2) { create(:user) }

  it { should belong_to(:admin).class_name('User').with_foreign_key('admin_id') }
  it { should have_and_belong_to_many(:participants).class_name('User') }
  it { should have_many(:pairs).dependent(:destroy) }

  it 'returns the second participant in ascending order of their registration time' do
    box = Box.create(admin: admin, participants: [participant1, participant2])
    expect(box.second_registered_user).to eq(participant2)
  end

  it 'returns nil if there are no participants' do
    box = Box.create(admin: admin)
    expect(box.second_registered_user).to be_nil
  end

  it 'returns nil if there is only one participant' do
    box = Box.create(admin: admin, participants: [participant1])
    expect(box.second_registered_user).to be_nil
  end

end
