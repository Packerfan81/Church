class AddLastNameToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :last_name, :string
  end
end
