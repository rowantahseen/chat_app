class AddChatToApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :chats, :application, foreign_key: true
  end
end
