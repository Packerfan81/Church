class AddStatusToCheckIns < ActiveRecord::Migration[7.2]
  def up
    # Change the column type with explicit USING clause
    execute <<-SQL
      ALTER TABLE check_ins
      ALTER COLUMN status TYPE integer USING CASE
        WHEN status = 'pending' THEN 0
        WHEN status = 'completed' THEN 1
        ELSE 0
      END;
    SQL

    # Set a default value and NOT NULL constraint
    change_column_default :check_ins, :status, 0
    change_column_null :check_ins, :status, false
  end

  def down
    # Revert the column to string
    change_column :check_ins, :status, :string
  end
end