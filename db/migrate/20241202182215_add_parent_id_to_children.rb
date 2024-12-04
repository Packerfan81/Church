class AddParentIdToChildren < ActiveRecord::Migration[7.2]
  def change
    add_column :children, :parent_id, :bigint
  end
end
