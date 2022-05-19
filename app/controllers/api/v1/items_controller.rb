module Api
    module V1
        class ItemsController < ApplicationController
            before_action :set_todo
            before_action :check_items, only: [:index, :update, :show, :destory]

            # GET /api/v1/todos/:todo_id/items
            def index
                @items = @todo.items                
                render json: {message: "success", data: @items}, status: :ok
            end
            
            # GET /api/v1/todos/:todo_id/items/:id
            def show
                @item = @todo.items.find(params[:id])
                render json: {message: "success", data: @item}, status: :ok
            end

            # POST /api/v1/todos/:todo_id/items
            def create
                @item = @todo.items.create!(item_params)
                render json: {message: "success", data: @item}, status: :created
            end
            
            # PUT /api/v1/todos/:todo_id/items/:id
            def update
                @item = @todo.items.find(params[:id])
                @item.update(item_params)
                render json: {message: "success", data: @item}, status: :ok
            end
            
            # DELETE /api/v1/todos/:todo_id/items/:id
            def destroy
                @item = @todo.items.find(params[:id])
                @item.destroy
                render status: :no_content
            end
            
            private

            def item_params
                params.permit(:name, :done)
            end

            def set_todo
                @todo = Todo.find(params[:todo_id])
            end
            
            def check_items
                if @todo.items.size == 0
                    render json: {message: "Couldn't find Items for this Todo"}, status: :not_found
                end
            end
        end
    end
end
