# spec/routes/routes_spec.rb

require 'rails_helper'

RSpec.describe 'Routes', type: :routing do

  describe 'User routes' do
    it { should route(:get, '/users/1').to('users#show', id: '1') }
    it { should route(:put, '/users/1').to('users#update', id: '1') }
    it { should route(:delete, '/users/1').to('users#destroy', id: '1') }
  end

  describe 'Wishlist routes' do
    it { should route(:post, '/users/1/wishlists/filtered_index').to('wishlists#filtered_index', user_id: '1') }
    it { should route(:get, '/users/1/wishlists/2').to('wishlists#show', user_id: '1', id: '2') }
    it { should route(:put, '/users/1/wishlists/2').to('wishlists#update', user_id: '1', id: '2') }
    it { should route(:delete, '/users/1/wishlists/2').to('wishlists#destroy', user_id: '1', id: '2') }
  
  end

  describe 'Box routes' do
    it { should route(:post, '/boxes/filtered_index').to('boxes#filtered_index') }
    it { should route(:get, '/boxes/1').to('boxes#show', id: '1') }
    it { should route(:put, '/boxes/1').to('boxes#update', id: '1') }
    it { should route(:delete, '/boxes/1').to('boxes#destroy', id: '1') }
    it { should route(:post, '/boxes/1/add_participant').to('boxes#add_participant', id: '1') }
    it { should route(:delete, '/boxes/1/remove_participant').to('boxes#remove_participant', id: '1') }
    it { should route(:get, '/boxes/1/start').to('boxes#start', id: '1') }
    
  end
end
