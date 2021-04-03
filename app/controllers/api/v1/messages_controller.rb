module Api
  module V1    
    class MessagesController < ApplicationController
      before_action :find_application, :find_chat
      before_action :set_message, only: [:show, :update, :destroy]
      

      # GET /messages
      def index
        @q = params.fetch(:search_query) if params[:search_query]
        if @q 
          @messages = Message.search(@q, fields: ['body'], where: {chat_id: @chat.id})
          render json: @messages, :except => [:id, :chat_id]
        else
          @messages = Message.where(chat_id: @chat.id)
          render json: @messages, :except => [:id, :chat_id]
        end
      end

      # GET /messages/1
      def show
        render json: @message, :except => [:id, :chat_id]
      end

      # POST /messages
      def create

        if $redis.exists?("#{@application.acess_token}___#{params[:chat_id]}___count") && $redis.get("#{@application.acess_token}___#{params[:chat_id]}___count").to_i >= 1
          @number = $redis.incr("#{@application.acess_token}___#{params[:chat_id]}___count")
          MessageWorker.perform_async(@chat.id, @number, params[:body])
        else
          @number = 1
          MessageWorker.perform_async(@chat.id, @number, params[:body])
          $redis.set("#{@application.acess_token}___#{params[:chat_id]}___count", 1)
        end

        render json: @number
      end

      # PATCH/PUT /messages/1
      def update
        if @message.update(message_params)
          render json: @message
        else
          render json: @message.errors, status: :unprocessable_entity
        end
      end

      # DELETE /messages/1
      def destroy
        @message.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_message
          @message = Message.cached_message(params[:application_id], params[:chat_id], params[:id])
        end

        def find_application
          @application = Application.cached_app(params[:application_id])
        end

        def find_chat
          @chat = Chat.find_chat(params[:application_id] ,params[:chat_id])
        end

        # Only allow a trusted parameter "white list" through.
        def message_params
          params.require(:message).permit(:number, :body, :search_query)
        end
    end
  end
end
