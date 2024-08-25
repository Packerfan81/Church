class CreateChildren < ActiveRecord::Migration[7.2]
  def change
    create_table :children do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :grade
      t.text :food_allergies
      t.text :special_medical_needs
      t.string :emergency_contact
      t.references :parent, null: false, foreign_key: true

      t.timestamps
    end
  end
end
