require 'rails_helper'

RSpec.describe V1::CategoriesController, type: :controller do
  describe "#index" do
    let!(:category) { create(:category) }

    before :each do
      get :index
      @categories = JSON.parse(response.body)["categories"]
    end    

    it "returns success" do
      expect(response).to have_http_status(:ok)
    end
    
    it "returns id" do
      expect(@categories.first['id']).to eq(category.id)
    end

    it "returns name" do
      expect(@categories.first['name']).to eq(category.name)
    end   
  end
end
