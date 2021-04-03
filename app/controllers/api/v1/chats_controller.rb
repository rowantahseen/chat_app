module Api
  module V1
    class ChatsController < ApplicationController
      before_action :find_application
      before_action :set_chat, only: [:show, :update, :destroy]
      

      # GET /application/[app_token]/chats
      def index
        @chats = Chat.where(application: @application.id)

        render json: @chats, :except => [:id, :application_id]
      end

      # GET /chats/1
      def show
        render json: @chat, :except => [:id, :application_id]
      end

      # POST /chats
      def create
        if $redis.exists?("#{@application.acess_token}_count") && $redis.get("#{@application.acess_token}_count").to_i >= 1
          @number = $redis.incr("#{@application.acess_token}_count")
          ChatWorker.perform_async(@application.id, @number)
          # @chat = Chat.new(application_id: @application.id, number: @number)
        else
          # @chat = Chat.new(number: 1, application_id: @application.id)
          $redis.set("#{@application.acess_token}_count", 1)
          @number = 1
          ReportWorker.perform_async(@application.id, @number)
        # @chat = Chat.new(number: @application.chats_count +1)
        end

        render json: @number
  
      end

      # PATCH/PUT /chats/1
      def update
        if @chat.update(chat_params)
          render json: @chat
        else
          render json: @chat.errors, status: :unprocessable_entity
        end
      end

      # DELETE /chats/1
      def destroy
        @chat.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.

        def find_application
          @application = Application.cached_app(params[:application_id])
        end

        def set_chat
          @chat = Chat.find_chat(params[:application_id] ,params[:id])
          # puts(@chat)
        end

        # Only allow a trusted parameter "white list" through.
        def chat_params
          params.require(:chat).permit(:number)
        end
    end
  end
end
