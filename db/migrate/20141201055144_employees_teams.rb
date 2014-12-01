class EmployeesTeams < ActiveRecord::Migration
  def change
    create_table :employees_teams, id: false do |t|
      t.belongs_to :team
      t.belongs_to :employee
    end
  end
end
