class MessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(id, num, text)
        message = Message.new(chat_id: id, number: num, body: text )
        message.save!
    end
end