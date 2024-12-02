class AddDeletedAtToChildrenAndParents < ActiveRecord::Migration[7.2]
  def change
    add_column :children, :deleted_at, :datetime
    add_column :parents, :deleted_at, :datetime
    add_index :children, :deleted_at
    add_index :parents, :deleted_at
  end
end
