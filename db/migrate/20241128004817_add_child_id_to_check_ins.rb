class AddChildIdToCheckIns < ActiveRecord::Migration[7.2]
  def change
    add_reference :check_ins, :child, null: false, foreign_key: true
  end
end
