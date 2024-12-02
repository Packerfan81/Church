class AddParentIdToParents < ActiveRecord::Migration[7.2]
  def change
    add_column :parents, :parent_id, :integer
    add_index :parents, :parent_id
  end
end
