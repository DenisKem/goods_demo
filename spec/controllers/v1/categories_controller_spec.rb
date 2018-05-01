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
    
    it "returns category" do
      expect(@categories.first['id']).to eq(category.id)
    end  
  end

  describe "#create" do
    subject { post :create, params: Hash['category', category_params] }
    
    let(:category_name) { "Food" }
    let(:category_params) { Hash[:name, category_name] }
    
    context "with valid params" do
      it "creates category" do
        expect { subject }.to change { Category.count }.from(0).to(1)
      end      

      it "returns http status created" do
        subject
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      shared_examples_for :failed_creating_category  do
        it "does not create category" do
          expect { subject }.to_not change { Category.count }.from(1)
        end

        it "returns http status unprocessable_entity" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end      

      context "when name has already been taken" do
        before :each do
          create(:category, name: category_name)
        end

        it_behaves_like :failed_creating_category

        it "returns name has already been taken" do
          subject
          expect(JSON.parse(response.body)['errors']['name']).to include("has already been taken")
        end
      end

      # In case of name is blank ActionController::ParameterMissing will be raised
    end    
  end  
end
