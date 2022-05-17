class ApplicationController < ActionController::API
    # Exception Handlers
    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {message: e.message}, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {message: e.message}, status: :unprocessable_entity
    end
end
