class AddUserIdToParents < ActiveRecord::Migration[7.2]
  def change
    add_column :parents, :user_id, :integer
  end
end
