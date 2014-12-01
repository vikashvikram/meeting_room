class MyApp < Sinatra::Application
	get '/meetings' do
	  @meetings = Meeting.all
	  json @meetings.to_json
	end

	get '/meetings/:id' do
	  @meeting = Meeting.find(params[:id])
	  json @meeting.to_json
	end

	post '/meetings' do
	  @meeting = Meeting.new(params[:meeting])
	  if @meeting.save
	    json message: "Successfully created meeting with ID: #{@meeting.id}"
	  else
	    json message: "Unsuccessful meeting creation", errors: @meeting.errors.full_messages
	  end
	end

	delete '/meetings/:id' do
	  @meeting = Meeting.find(params[:id])
	  if @meeting.destroy
	    json message: "Successfully deleted"
	  else
	    json message: "Unsuccessful deletion", errors: @meeting.errors.full_messages
	  end
	end

	put '/meetings/:id' do
	  @meeting = Meeting.find(params[:id])
	  if @meeting.update(params[:meeting])
	    json message: "Successfully updated meeting with ID: #{@meeting.id}"
	  else
	    json message: "Unsuccessful update", errors: @meeting.errors.full_messages
	  end
	end

	patch'/meetings/:id' do
	  @meeting = Meeting.find(params[:id])
	  if @meeting.update_attributes(params[:meeting])
	    json message: "Successfully patched meeting with ID: #{@meeting.id}"
	  else
	    json message: "Unsuccessful patch", errors: @meeting.errors.full_messages
	  end
	end
end
