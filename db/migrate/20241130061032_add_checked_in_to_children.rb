class AddCheckedInToChildren < ActiveRecord::Migration[7.2]
  def change
    add_column :children, :checked_in, :boolean, default: false, null: false
  end
end
