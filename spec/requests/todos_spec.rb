require 'rails_helper'

RSpec.describe "Todos API", type: :request do
  
  # Factory Data
  let!(:todos) {create_list(:todo, 5)}
  let(:todo_id) { todos.first.id }
  
  # Test suite for GET /todos
  describe "GET /todos" do
    context "Todos exist" do
      before {get '/api/v1/todos'}
      
      it "return all todos" do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty  
        expect(json["data"].size).to eq(5) 
      end
  
      it "return status code 200" do
        expect(response).to have_http_status(200)
      end
    end
    
    context "Todos empty" do
      let(:todos) {}
      before {get '/api/v1/todos'}

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  # Test Suite for GET /api/v1/todos/id
  describe "GET /api/v1/todos/:id" do
    context "when the record exists" do
      before {get "/api/v1/todos/#{todo_id}"}

      it "returns the record" do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json["data"]["id"]).to eq(todo_id)
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
    
    context "when the record doesn't exist" do
      let(:todo_id) {100}
      before {get "/api/v1/todos/#{todo_id}"}
      
      it "returns 'couldnt find todo'" do
        json = JSON.parse(response.body)
        expect(json["message"]).to match(/Couldn't find Todo/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404) 
      end
    end
  end

  # Test suite for POST /todos
  describe "POST /todos" do

    context "when the request is valid" do
      before {post "/api/v1/todos", params: {title: "Interview", created_by: "Hussein"}}
      
      it "the record is created" do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json["data"]["title"]).to eq("Interview")   
      end
      
      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "Invalid request" do
      # empty created_by
      before {post "/api/v1/todos", params: {title: "Interview"}}

      it "returns status code 422" do
        expect(response).to have_http_status(422) 
      end
    end
  end
  
  # Test suite for PUT /todos/:id
  describe "PUT /api/v1/todos/id" do
    
    context "when the record doesn't exist" do
      let(:todo_id) {100}
      before {put "/api/v1/todos/#{todo_id}", params: {title: "new_title", created_by: "hussein"}}

      it "returns status code 404" do
        expect(response).to have_http_status(404) 
      end
    end
    
    context "when the record exists" do
      before {put "/api/v1/todos/#{todo_id}", params: {title: "new_title", created_by: "hussein"}}

      it "returns updated todo" do
        json = JSON.parse(response.body)
        expect(json["data"]["title"]).to eq("new_title")
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200) 
      end
    end
    
  end
  
  # Test suite for Delete /todos/:id
  describe "DELETE /api/v1/todos/id" do
    
    context "when the record doesn't exist" do
      let(:todo_id) {todos.last.id+1}
      before {delete "/api/v1/todos/#{todo_id}"}
  
      it "returns status code 404" do
        expect(response).to have_http_status(404) 
      end
    end

    context "when the record exists" do
      before {delete "/api/v1/todos/#{todo_id}"}

      it "Removes the record" do
        expect(response.body).to be_empty 
      end
      
      it "returns status code 204 no_content" do
        expect(response).to have_http_status(204) 
      end
    end
  end
end
