class AddCheckOutPreferenceToParents < ActiveRecord::Migration[7.2]
  def change
    add_column :parents, :check_out_preference, :string, default: 'email'
  end
end
