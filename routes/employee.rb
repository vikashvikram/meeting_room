class MyApp < Sinatra::Application
	get '/employees' do
	  @employees = Employee.all
	  json @employees
	end

	get '/employees/:id' do
	  @employee = Employee.find(params[:id])
	  json @employee
	end

	post '/employees' do
	  @employee = Employee.new(params[:employee])
	  if @employee.save
	    json message: "Successfully created employee with ID: #{@employee.id}"
	  else
	    json message: "Unsuccessful employee creation", errors: @employee.errors.full_messages
	  end
	end

	delete '/employees/:id' do
	  @employee = Employee.find(params[:id])
	  if @employee.destroy
	    json message: "Successfully deleted"
	  else
	    json message: "Unsuccessful deletion", errors: @employee.errors.full_messages
	  end
	end

	put '/employees/:id' do
	  @employee = Employee.find(params[:id])
	  if @employee.update(params[:employee])
	    json message: "Successfully updated employee with ID: #{@employee.id}"
	  else
	    json message: "Unsuccessful update", errors: @employee.errors.full_messages
	  end
	end

	patch'/employees/:id' do
	  @employee = Employee.find(params[:id])
	  if @employee.update_attributes(params[:employee])
	    json message: "Successfully patched employee with ID: #{@employee.id}"
	  else
	    json message: "Unsuccessful patch", errors: @employee.errors.full_messages
	  end
	end
end
