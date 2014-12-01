class EmployeesMeetings < ActiveRecord::Migration
  def change
    create_table :employees_meetings, id: false do |t|
      t.integer :meeting_id
      t.integer :employee_id
    end
  end
end
