class AddFullNameAndParentEmailToCheckIns < ActiveRecord::Migration[7.2]
  def change
    add_column :check_ins, :parent_email, :string
  end
end
