class AddTrackableColumnsToParents < ActiveRecord::Migration[7.2]
  def change
    add_column :parents, :current_sign_in_at, :datetime
    add_column :parents, :last_sign_in_at, :datetime
    add_column :parents, :current_sign_in_ip, :string
    add_column :parents, :last_sign_in_ip, :string
    add_column :parents, :sign_in_count, :integer
  end
end
