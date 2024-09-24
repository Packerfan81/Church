class AddFirstNameToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :first_name, :string
  end
end
