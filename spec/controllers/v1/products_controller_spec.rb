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
  
  describe "#create" do
    subject { post :create, params: Hash['product', product_params] }
    let(:initial_products_count) { 0 }
    let(:new_products_count) { 1 }

    shared_examples_for :succeessful_created do      
      it "creates product" do
        expect { subject }.to change { Product.count }.from(initial_products_count).to(new_products_count)
      end      

      it "returns http status created" do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'updates category products_count' do
        expect{subject; category.reload}.to change{category.products_count}.from(0).to(1)
      end
    end
    
    context "with valid params" do
      let(:category) { create(:category) }
      let(:product_params) { Hash[:category_id, category.id, :price, 700, :name, 'test'] }  
      
      it_behaves_like :succeessful_created  
    end

    context "when name has been taken in other category" do
      let(:initial_products_count) { 1 }
      let(:new_products_count) { 2 }
      let(:category) { create(:category) }
      let(:product_params) { Hash[:category_id, category.id, :price, 700, :name, 'test'] }

      before(:each) do
        create(:product, name: 'test')
      end
      
      it_behaves_like :succeessful_created 
    end 

    shared_examples_for :unprocessable_entity do
      it "returns http status unprocessable_entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when name is blank" do
      let(:category) { create(:category) }
      let(:product_params) { Hash[:category_id, category.id, :price, 700] }

      it_behaves_like :unprocessable_entity

      it "returns name is blank" do
        subject
        expect(JSON.parse(response.body)['errors']['name']).to include("can't be blank")
      end
    end

    context "when category_id is blank" do
      let(:category) { create(:category) }
      let(:product_params) { Hash[:price, 700, :name, 'test'] }

      it_behaves_like :unprocessable_entity

      it "returns category must exist" do
        subject
        expect(JSON.parse(response.body)['errors']['category']).to include("must exist")
      end
    end

    context "when name has been taken" do
      let(:category) { create(:category) }
      let(:product_params) { Hash[:category_id, category.id, :price, 700, :name, 'test'] }  
      
      before :each do
        create(:product, category: category, name: 'test')
      end

      it_behaves_like :unprocessable_entity

      it "returns name has already been taken" do
        subject
        expect(JSON.parse(response.body)['errors']['name']).to include("has already been taken")
      end
    end

    context "when price is less than or equal 0" do
      let(:category) { create(:category) }
      let(:product_params) { Hash[:category_id, category.id, :price, -700, :name, 'test'] }  

      it_behaves_like :unprocessable_entity

      it "returns name has already been taken" do
        subject
        expect(JSON.parse(response.body)['errors']['price']).to include("must be greater than 0")
      end
    end   
  end 
  
  describe "#destroy" do
    let!(:product) { create(:product) }
    let(:category) { product.category }

    subject { delete :destroy, params: {id: product.id} }

    it "returns 200 status" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "deletes product" do
      expect { subject }.to change { Product.count }.from(1).to(0)
    end
    
    it "updates category products_count" do
      expect { subject; category.reload }.to change { category.products_count }.from(1).to(0)
    end    
  end  
end
