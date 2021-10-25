class AddSaltToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :salt, :string
  end
end
