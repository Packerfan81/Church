class AddIndexToChildrenParentEmail < ActiveRecord::Migration[7.2]
  def change
    add_index :children, :parent_email
  end
end
