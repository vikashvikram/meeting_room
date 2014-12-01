class MyApp < Sinatra::Application
	get '/teams' do
	  @teams = Team.all
	  json @teams.to_json
	end

	get '/teams/:id' do
	  @team = Team.find(params[:id])
	  json @team.to_json
	end

	post '/teams' do
	  @team = Team.new(params[:team])
	  if @team.save
	    json message: "Successfully created team with ID: #{@team.id}"
	  else
	    json message: "Unsuccessful team creation", errors: @team.errors.full_messages
	  end
	end

	delete '/teams/:id' do
	  @team = Team.find(params[:id])
	  if @team.destroy
	    json message: "Successfully deleted"
	  else
	    json message: "Unsuccessful deletion", errors: @team.errors.full_messages
	  end
	end

	put '/teams/:id' do
	  @team = Team.find(params[:id])
	  if @team.update(params[:team])
	    json message: "Successfully updated team with ID: #{@team.id}"
	  else
	    json message: "Unsuccessful update", errors: @team.errors.full_messages
	  end
	end

	patch'/teams/:id' do
	  @team = Team.find(params[:id])
	  if @team.update_attributes(params[:team])
	    json message: "Successfully patched team with ID: #{@team.id}"
	  else
	    json message: "Unsuccessful patch", errors: @team.errors.full_messages
	  end
	end
end
