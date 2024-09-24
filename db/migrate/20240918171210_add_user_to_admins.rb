class AddUserToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_reference :admins, :user, null: false, foreign_key: true
  end
end