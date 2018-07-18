class Room < ApplicationRecord
    has_and_belongs_to_many :tags

    after_commit :scan_hashtag_from_body, on: :create
    after_commit :update_hashtag_from_body, on: :update


    def update_hashtag_from_body
       room = Room.find_by(id: self.id)
        hashtags = self.hashtag.split('#')
        transaction do
            hashtags[1..-1].map do |hashtag|
                next if self.tags.where(name: hashtag).first
                tag = Tag.find_or_create_by(name: hashtag.downcase.strip)
                RoomsTag.create(room_id: self.id, tag_id: tag.id)
            end
        end 
    end
    
    def scan_hashtag_from_body
        room = Room.find_by(id: self.id)
        hashtags = self.hashtag.split('#')
        transaction do
            hashtags[1..-1].map do |hashtag|
                tag = Tag.find_or_create_by(name: hashtag.downcase.strip)
                RoomsTag.create(room_id: self.id, tag_id: tag.id)
            end
        end
    end


end
