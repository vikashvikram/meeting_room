require 'sinatra'
require "sinatra/json"
require 'sinatra/activerecord'
require './environments'


class Employee < ActiveRecord::Base
  self.primary_key = :sap_id
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :meetings
  
  validates :email, uniqueness: true, presence: true
end

class Team < ActiveRecord::Base
  has_and_belongs_to_many :employees
  
  validates :name, uniqueness: true, presence: true
end

class Meeting < ActiveRecord::Base
  belongs_to :conference_room
  has_and_belongs_to_many :participants, class_name: "Employee"

  validates :start_time, presence: true, uniqueness: true
  validates :end_time, presence: true, uniqueness: true
end

class ConferenceRoom < ActiveRecord::Base
  has_many :meetings
  validates :name, presence: true, uniqueness: true
end

get '/' do
  json message: "Welcome To Meeting Room App"
end

get '/employees' do
  @employees = Employees.all
  json @employees.to_json
end

get '/employees/:id' do
  @employee = Employee.find(params[:id])
  json @employee.to_json
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
