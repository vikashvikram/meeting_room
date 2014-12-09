class MyApp < Sinatra::Application
	post '/assign_team' do
		@employee = Employee.find(params[:employee_id])
		@team = Team.find(params[:team_id])
		@employee.teams << @team unless @employee.teams.include? @team
		json message: "Employee #{@employee.name} has been assigned to Team #{@team.name}"
	end
	post '/deassign_team' do
		@employee = Employee.find(params[:employee_id])
		@team = Team.find(params[:team_id])
		@employee.teams.delete(@team)
		json message: "Employee #{@employee.name} has been deassigned from Team #{@team.name}"
	end
	post '/parse' do
		@message = params[:message]
		@result = %x{ python /home/vk/Documents/projects/Formatting_Code/main.py \"#{@message}\"}
		json @result 
	end
end
