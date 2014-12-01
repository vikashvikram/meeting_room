require 'sinatra'
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
