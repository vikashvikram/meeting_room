class Employee < ActiveRecord::Base
  self.primary_key = :sap_id
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :meetings
  
  validates :email, uniqueness: true, presence: true
  validates :sap_id, uniqueness: true, presence: true
  validates :name, presence: true
  def self.get_participants(participants)
    @teams = Team.where('name in (?)', participants)
    @participants = @teams.map do |x| x.employees.map &:id end
    @participants << Employee.where('name in (?)', participants).map(&:id)
    @participants.flatten!.uniq!
  end
end

class Team < ActiveRecord::Base
  has_and_belongs_to_many :employees
  
  validates :name, uniqueness: true, presence: true
end

class Meeting < ActiveRecord::Base
  belongs_to :conference_room
  has_and_belongs_to_many :employees

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :conference_room, presence: true
  scope :overlaps, ->(start_time, end_time, conference_room_id) do
    where "((start_time <= ?) and (end_time >= ? and conference_room_id = ?))", start_time, end_time, conference_room_id
  end 

  validate :not_overlap

  def not_overlap
    errors.add(:message, 'Meeting Schedule Coincides') if overlaps? start_time, end_time, conference_room_id
  end

  def scheduler
    Employee.find(booked_by)
  end
  
  def overlaps? start_time, end_time, conference_id
    Meeting.overlaps(start_time, end_time, conference_room_id).exists?
  end
end

class ConferenceRoom < ActiveRecord::Base
  has_many :meetings
  validates :name, presence: true, uniqueness: true

  def self.available(start_time=nil, end_time=nil)
    all.select{|conf_room| conf_room.meetings.overlaps(start_time, end_time, conf_room.id).blank?}
  end
end
