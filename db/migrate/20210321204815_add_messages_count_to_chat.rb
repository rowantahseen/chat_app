class AddMessagesCountToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :msgs_count, :integer, default: 0
  end
end
