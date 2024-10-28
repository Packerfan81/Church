class AddDeviseFieldsToParents < ActiveRecord::Migration[7.2]
  def change
    add_column :parents, :encrypted_password, :string, null: false, default: ""
    add_column :parents, :reset_password_token, :string
    add_column :parents, :reset_password_sent_at, :datetime
    add_column :parents, :remember_created_at, :datetime

    add_index :parents, :reset_password_token, unique: true
  end
end
