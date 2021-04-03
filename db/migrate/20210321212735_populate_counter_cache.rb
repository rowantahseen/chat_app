class PopulateCounterCache < ActiveRecord::Migration[5.2]
  def up

    Application.all.each do |application|
      Application.reset_counters(application.id, :chats)
    end

    Chat.all.each do |chat|
      Chat.reset_counters(chat.id, :messages)
    end

  end
  
  def down
  end
end
