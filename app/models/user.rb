class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :admissions
  has_many :rooms, through: :admissions
  has_many :chats
  
  def joined_room?(room)
    # 유저가 그 방에 들어있는지 볼라구
    self.rooms.include?(room)
  end
   
  def is_ready?(room)
    self.admissions.where(room_id: room.id).first.ready_state
  end
end
