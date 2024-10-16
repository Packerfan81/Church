class CreateCheckIns < ActiveRecord::Migration[7.2]
  def change
    create_table :check_ins do |t|
      t.references :child, null: false, foreign_key: true
      t.datetime :check_in_time, null: false

      t.timestamps
    end
  end
end