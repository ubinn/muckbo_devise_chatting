class CreateRoomsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms_tags, :id => false do |t|
      t.references :room, foreign_key: true
      t.references :tag, foreign_key: true
    end
  end
end
