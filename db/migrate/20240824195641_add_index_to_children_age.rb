class AddIndexToChildrenAge < ActiveRecord::Migration[7.2]
  def change
    add_index :children, :age
  end
end
