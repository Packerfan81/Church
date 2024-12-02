class AddCompositeIndexToCheckIns < ActiveRecord::Migration[7.2]
  def change
    add_index :check_ins, [:child_id, :parent_id], name: 'index_check_ins_on_child_id_and_parent_id'
  end

end
