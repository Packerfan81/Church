class AddStatusToChildren < ActiveRecord::Migration[7.2]
  def change
    add_column :children, :status, :integer
  end
end
