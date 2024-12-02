class AddNotNullConstraints < ActiveRecord::Migration[7.2]
   # Fill existing null values for full_name and parent_email
    CheckIn.where(full_name: nil).update_all(full_name: "Unknown")
    CheckIn.where(parent_email: nil).update_all(parent_email: "unknown@example.com")

    # Add NOT NULL constraints
    change_column_null :check_ins, :full_name, false
    change_column_null :check_ins, :parent_email, false
  end

  def down
    # Remove NOT NULL constraints
    change_column_null :check_ins, :full_name, true
    change_column_null :check_ins, :parent_email, true
  end
