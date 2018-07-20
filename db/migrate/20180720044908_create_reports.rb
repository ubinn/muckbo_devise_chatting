class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      
      t.string :user_email
      t.integer :user_id
      
      t.integer :report_reason
      t.text :report_description
      
      t.timestamps
    end
  end
end
