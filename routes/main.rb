require 'json'
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
		@result = %x{ python /home/vk/Documents/projects/Formatting_Code/main.py '#{@message}'}
		data = JSON.parse(@result)
		logger.info "message: #{@message}"
		logger.info "result: #{@result}"
                unless data["result"] == "Fail"
			cr =  ConferenceRoom.find_by(name: data["conf_room"]).try(:id)
			bb =  Employee.find_by(name: data["booked_by"]).id
			data = data.each { |k, v| data["conf_room"] = cr }
			data = data.each { |k, v| data["booked_by"] = bb }
		end	
		json [data] 
	end
	get '/available_rooms' do
		@rooms = ConferenceRoom.available(params[:start_time], params[:end_time])
		json @rooms
	end
end
