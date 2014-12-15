class MyApp < Sinatra::Application
	get '/meetings' do
	  @meetings = Meeting.all
	  json @meetings
	end

	get '/meetings/:id' do
	  @meeting = Meeting.find(params[:id])
	  json @meeting
	end

	post '/meetings' do
	  @participants = Employee.get_participants(params[:meeting][:participants].split(',').map(&:strip))
	  @meeting = Meeting.new(params[:meeting].except("participants"))
	  if @meeting.save
            @meeting.employees << Employee.find(@participants)
	    json message: "Successfully created meeting with ID: #{@meeting.id}", result: "Success", meeting_id: @meeting.id
	  else
	    json message: "Unsuccessful meeting creation", errors: @meeting.errors.full_messages, result: "Fail"
	  end
	end

	delete '/meetings/:id' do
	  @meeting = Meeting.find(params[:id])
	  if @meeting.destroy
	    json message: "Successfully deleted", result: "Success"
	  else
	    json message: "Unsuccessful deletion", errors: @meeting.errors.full_messages, result: "Fail"
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
