class AddForeignKeyToAdminsUserId < ActiveRecord::Migration[7.2]
  def change
     add_primary_key :admins, :users
     add_foreign_key :admins, :users
  end
end
