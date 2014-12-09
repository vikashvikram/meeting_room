class MyApp < Sinatra::Application
	get '/conference_rooms' do
	  @conference_rooms = ConferenceRoom.available(params[:start_time], params[:end_time])
	  json @conference_rooms.to_json
	end

	get '/conference_rooms/:id' do
	  @conference_room = ConferenceRoom.find(params[:id])
	  json @conference_room.to_json
	end

	post '/conference_rooms' do
	  @conference_room = ConferenceRoom.new(params[:conference_room])
	  if @conference_room.save
	    json message: "Successfully created conference_room with ID: #{@conference_room.id}"
	  else
	    json message: "Unsuccessful conference_room creation", errors: @conference_room.errors.full_messages
	  end
	end

	delete '/conference_rooms/:id' do
	  @conference_room = ConferenceRoom.find(params[:id])
	  if @conference_room.destroy
	    json message: "Successfully deleted"
	  else
	    json message: "Unsuccessful deletion", errors: @conference_room.errors.full_messages
	  end
	end

	put '/conference_rooms/:id' do
	  @conference_room = ConferenceRoom.find(params[:id])
	  if @conference_room.update(params[:conference_room])
	    json message: "Successfully updated conference_room with ID: #{@conference_room.id}"
	  else
	    json message: "Unsuccessful update", errors: @conference_room.errors.full_messages
	  end
	end

	patch'/conference_rooms/:id' do
	  @conference_room = ConferenceRoom.find(params[:id])
	  if @conference_room.update_attributes(params[:conference_room])
	    json message: "Successfully patched conference_room with ID: #{@conference_room.id}"
	  else
	    json message: "Unsuccessful patch", errors: @conference_room.errors.full_messages
	  end
	end
end
