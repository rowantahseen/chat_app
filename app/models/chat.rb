class Chat < ApplicationRecord
    belongs_to :application, counter_cache: :chats_count
    has_many :messages
    validates :number, presence: true
    validates_uniqueness_of :number, scope: :application_id

    def self.find_chat(token, id)
        app = Application.cached_app(token)
        Rails.cache.fetch("#{token}|#{id}", expires_in: 1.hour){
            Chat.where(application_id: app.id, number: id).first
        }
    end
    # def self.find_chats(app_id, token, id)
    #     Rails.cache.fetch("#{token}|#{id}_all"){
    #         Chat.find_by(number: id, application_id: app_id)
    #     }
    #     Chat.all.each do |chat|
    #     Rails.cache.write("#{token}|#{id}", Message.joins(:chat).where(chat: {application_id: app_id}))
    #     end
    # end
end
