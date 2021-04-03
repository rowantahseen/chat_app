class Message < ApplicationRecord
    belongs_to :chat, counter_cache: :msgs_count
    validates_uniqueness_of :number, scope: :chat_id
    validates :body, presence: true
    searchkick

    def self.cached_message(token, number, msg_number)
        chat = Chat.find_chat(token,number)
        Rails.cache.fetch("#{token}|#{number}|#{msg_number}"){
            Message.where(chat_id: chat.id, number: msg_number).first

            # Message.joins(:chats).where("chats.application" ==> app_id)
            # Message.includes(:details).where(:id => current_account_id)
            # Account.joins(:details).where("details.name" => selected_detail).first

        }
    end
            # Message.includes(:chat => [:application_id]).where(application_id: app_id)

    # end
    
    # def self.find_message(num, app_id, token, id)
    #     messages = Message.cached_messages(app_id, token, id)
    #     messages.each do |message|
    #         if message[:number] == num
    #             return mesasge
    #         end
    #     end
    # end

end
