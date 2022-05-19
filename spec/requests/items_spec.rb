require 'rails_helper'

RSpec.describe "Items", type: :request do
  
  let!(:todo_with_items) {create(:todo)}
  let!(:todo_with_Noitems) {create(:todo)}
  let!(:items) {create_list(:item, 5, todo_id: todo_with_items.id)}
  let(:todo_id) {todo_with_items.id}
  let(:item_id) {items.first.id}
  
  # Test Suite for GET /api/v1/todos/:todo_id/items 
  describe "GET /api/v1/todos/:todo_id/items" do
    context "when todo isn't found" do
      let(:todo_id) {100}
      before {get "/api/v1/todos/#{todo_id}/items"}
      
      it "return todo not found" do
        json = JSON.parse(response.body)
        expect(json["message"]).to  match(/Couldn't find Todo/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404) 
      end
    end
    
    context "todo with no items" do
      let(:todo_id) {todo_with_Noitems.id}
      before {get "/api/v1/todos/#{todo_id}/items"}
      
      it "return items not found" do
        json = JSON.parse(response.body)
        expect(json["message"]).to  match(/Couldn't find Items/)
      end
      
      it "returns status code 404" do
        expect(response).to have_http_status(404) 
      end
    end
    
    context "a todo with items" do
      before {get "/api/v1/todos/#{todo_id}/items"}

      it "returns all items" do
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("success")
        expect(json["data"].size).to eq(5)
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200) 
      end
    end    
  end

  # Test Suite for GET /todos/:todo_id/items/:id
  describe "GET /api/v1/todos/:todo_id/items/:id" do
    
    context "when the record doesn't exist" do
      let(:item_id) { 100 } 
      before {get "/api/v1/todos/#{todo_id}/items/#{item_id}"}

      it "returns item not found" do
        json = JSON.parse(response.body)
        expect(json["message"]).to match(/Couldn't find Item/)  
      end
      
      it "returns status code 404" do
        expect(response).to have_http_status(404) 
      end
    end

    context "when the record exists" do
      before {get "/api/v1/todos/#{todo_id}/items/#{item_id}"}

      it "returns the item" do
        json = JSON.parse(response.body)
        expect(json["data"]["id"]).to eq(item_id)
        expect(json["data"]["name"]).to eq(items.first.name)
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
  end
  
  # Test Suite for POST /todos/:todo_id/items
  describe "POST /api/v1/" do
    
    context "valid item" do
      before {post "/api/v1/todos/#{todo_id}/items", params: {name: "SOLID principles"}}
      
      it "returns created item" do
        json = JSON.parse(response.body)
        expect(json["data"]["todo_id"]).to eq(todo_id) 
        expect(json["data"]["name"]).to eq("SOLID principles")
      end
      
      it "returns status code 201" do
        expect(response).to have_http_status(201) 
      end
    end
    
    context "invalid item" do
      before {post "/api/v1/todos/#{todo_id}/items"}
        
      it "returns status code 422" do
        expect(response).to have_http_status(422) 
      end
    end
  end

  # Test Suite PUT /api/v1/todos/:todo_id/items/:id
  describe "PUT /api/v1/todos/:todo_id/items/:id" do
    
    context "valid item" do
      let(:valid_item) { {name: "item2", done: true} } 
      before {put "/api/v1/todos/#{todo_id}/items/#{item_id}", params: valid_item}
      
      it "returns the item" do
        json = JSON.parse(response.body)
        expect(json["data"]["name"]).to eq(valid_item[:name])
        expect(json["data"]["done"]).to eq(valid_item[:done])
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200) 
      end
    end
  end
  
  # Test Suite DELETE /api/v1/todos/:todo_id/items/:id
  describe "DELETE /api/v1/todos/:todo_id/items/:id" do

    context "when the record doesn't exist" do
      let(:item_id) { items.last.id+1 } 
      before {delete "/api/v1/todos/#{todo_id}/items/#{item_id}"}

      it "returns record not found" do
        json = JSON.parse(response.body)
        expect(json["message"]).to match(/Couldn't find Item/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end

    context "when the record exists" do
      before {delete "/api/v1/todos/#{todo_id}/items/#{item_id}"}

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
    end
  end
end
