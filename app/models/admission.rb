class Admission < ApplicationRecord
  belongs_to :user
  belongs_to :room, counter_cache: true
  
 after_commit :user_join_room_notification, on: :create
 after_commit :user_exit_room_notification, on: :destroy
 after_commit :user_ready_check, on: :update
 
 
 
 
 def user_join_room_notification
     max_count = Room.where(id: self.room_id)[0].max_count
     admissions_count = Room.where(id: self.room_id)[0].admissions_count
   # 방에 들어갔을때 발생하는 트리거
   Pusher.trigger('room', 'join', self.as_json.merge({email: self.user.email, max_count: max_count,admissions_count: admissions_count }))
   Pusher.trigger("room_#{self.room_id}",'join', self.as_json.merge({email: self.user.email}))
 end
 
 def user_exit_room_notification
   Pusher.trigger("room",'exit',self.as_json)
   Pusher.trigger("room_#{self.room_id}",'exit',self.as_json)
 end
 
 def user_ready_check
   p "ready check"
   # p max_count = Room.where(id: self.room_id)[0].max_count
   max_count = Room.where(id: self.room_id)[0].max_count
   # ready_count = self.room.admissions.where(ready_state: true).size
   ready_count = Admission.where(room_id: self.room_id, ready_state: true).size
   
   Pusher.trigger("room_#{self.room_id}",'ready',self.as_json.merge({email: self.user.email, ready_count: ready_count, max_count: max_count}))
   if max_count == ready_count
     p "max_count == ready_count 코드  실행되고있당. "
     Pusher.trigger("room_#{self.room_id}",'start',self.as_json.merge({email: self.user.email, ready_count: ready_count, max_count: max_count}))
   end
 end 
end
