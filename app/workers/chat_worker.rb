class ChatWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(app_id, num)
        chat = Chat.new(application_id: app_id, number: num)
        chat.save!
    end
end