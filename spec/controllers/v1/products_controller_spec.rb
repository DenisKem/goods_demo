require 'rails_helper'

RSpec.describe V1::ProductsController, type: :controller do
  describe "#index" do
    let(:category1) { create(:category) }
    let!(:product1) { create(:product, category: category1) }
    let!(:product2) { create(:product) }
    
    before :each do
      get :index, params: {q: {category_id_eq: category1.id}}
      
      products = JSON.parse(response.body)["products"]
      @products_ids = products.map { |p| p['id'] }
    end
    
    it "returns 200 code" do
      expect(response).to have_http_status(:ok)
    end
    
    it "returns product1" do
      expect(@products_ids).to include(product1.id)
    end

    it "doesn't return product2" do
      expect(@products_ids).to_not include(product2.id)
    end    
  end  
end
