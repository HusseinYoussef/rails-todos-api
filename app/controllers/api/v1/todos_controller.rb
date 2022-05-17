module Api
  module V1
    # api/v1/{controller}
    class TodosController < ApplicationController

      # GET api/v1/todos
      def index
        @todos = Todo.all
        
        # empty list
        if @todos.size == 0
          return render json: {message: "Todos Not Found"}, status: :not_found
        end

        return render json: {status: 'success', data: @todos}, status: :ok
      end
      
      # GET api/v1/todos/:id
      def show
        @todo = Todo.find(params[:id])
        render json: {status: "success", data: @todo}, status: :ok
      end

      # POST /api/v1/todos
      def create
        @todo = Todo.create!(todo_params)
        return render json: {message: "success", data: @todo}, status: :created
      end
      
      # Delete /api/v1/todos/id
      def destroy
        @todo = Todo.find(params[:id])
        @todo.destroy
        render status: :no_content
      end
      
      # PUT /api/v1/todos/id
      def update
        @todo = Todo.find(params[:id])
        @todo.update(todo_params)
        return render json: {message: "success", data: @todo}, status: :ok
      end
      
      private
      def todo_params
        return params.permit(:title, :created_by)
      end
    end
  end
end