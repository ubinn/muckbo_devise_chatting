class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nickname, :string
    add_column :users, :major, :string
    add_column :users, :another_major, :string
    add_column :users, :sex, :string
  end
end
