class RemoveUserIdFromAdmins < ActiveRecord::Migration[7.2]
  def change
    remove_column :admins, :user_id, :bigint
  end
end
