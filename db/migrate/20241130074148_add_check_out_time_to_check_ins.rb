class AddCheckOutTimeToCheckIns < ActiveRecord::Migration[7.2]
  def change
    add_column :check_ins, :check_out_time, :datetime
  end
end
