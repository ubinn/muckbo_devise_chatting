class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      

      t.string   :room_title
      t.string   :master_id
      t.integer  :max_count
      t.integer  :admissions_count, default: 0
      t.boolean :room_state, default: false, null: false

      t.integer    :start_time_hour
      t.string    :start_time_min
      t.datetime    :meet_time_end
      t.string :hashtag
      t.string :food_type
      t.string :room_type
      
      t.timestamps
    end
  end
end
