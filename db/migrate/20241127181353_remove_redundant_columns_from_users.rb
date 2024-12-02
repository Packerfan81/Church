class RemoveRedundantColumnsFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :type, :string
    remove_column :users, :role, :integer
    remove_column :users, :password_digest, :string
  end
end
