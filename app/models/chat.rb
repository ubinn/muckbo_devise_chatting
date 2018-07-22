class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  after_commit :chat_message_notification, on: :create
  
 
 def chat_message_notification
   Pusher.trigger("room_#{self.room_id}", "chat", self.as_json.merge({email: self.user.email})) 
   p self
 end
  
end
