class AddCheckedInToChildren < ActiveRecord::Migration[7.2]
  def change
    change_column_default :children, :checked_in, from: nil, to: false
  end
end
