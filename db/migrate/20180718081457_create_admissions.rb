class CreateAdmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :admissions do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.boolean :ready_state, default: false, null: false

      t.timestamps
    end
  end
end
