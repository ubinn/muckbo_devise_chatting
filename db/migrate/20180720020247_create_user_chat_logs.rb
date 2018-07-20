class CreateUserChatLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :user_chat_logs do |t|
      t.string :room_title
      t.integer :room_id
      t.integer :user_id
      t.string :nickname
      t.date :chat_date

      t.timestamps
    end
  end
end
