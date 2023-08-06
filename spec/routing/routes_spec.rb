require 'rails_helper'

RSpec.describe "Routes", type: :routing do
  describe "Devise routes" do
    it "routes to login page" do
      expect(get: "/login").to route_to("users/sessions#new")
    end

    it "routes to logout page" do
      expect(delete: "/logout").to route_to("users/sessions#destroy")
    end

    it "routes to signup page" do
      expect(post: "/signup").to route_to("users/registrations#create")
    end

    # Add more tests for other Devise routes if needed
  end

  describe "User routes" do
    it "routes to show user page" do
      expect(get: "/users/1").to route_to("users#show", id: "1")
    end

    it "routes to update user page" do
      expect(put: "/users/1").to route_to("users#update", id: "1")
    end

    # Add more tests for other User routes if needed
  end

  describe "Wishlist routes" do
    it "routes to index wishlist page" do
      expect(get: "/users/1/wishlists").to route_to("wishlists#index", user_id: "1")
    end

    it "routes to show wishlist page" do
      expect(get: "/users/1/wishlists/2").to route_to("wishlists#show", user_id: "1", id: "2")
    end

    # Add more tests for other Wishlist routes if needed
  end

  describe "Box routes" do
    it "routes to start box page" do
      expect(get: "/boxes/1/start").to route_to("boxes#start", id: "1")
    end

    it "routes to add participant page" do
      expect(post: "/boxes/1/add_participant").to route_to("boxes#add_participant", id: "1")
    end

    it "routes to remove participant page" do
      expect(delete: "/boxes/1/remove_participant").to route_to("boxes#remove_participant", id: "1")
    end

    # Add more tests for other Box routes if needed
  end
end
