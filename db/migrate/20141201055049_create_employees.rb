class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees, id: false do |t|
      t.primary_key :sap_id
      t.string :name
      t.string :email, null: false

      t.timestamps
    end
  end
end
