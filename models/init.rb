class Employee < ActiveRecord::Base
  self.primary_key = :sap_id
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :meetings
  
  validates :email, uniqueness: true, presence: true
  validates :sap_id, uniqueness: true, presence: true
  validates :name, presence: true
  def self.get_participants(participants)
    unless participants.blank?
      @teams = Team.get_p(participants)
      @participants = @teams.map do |x| x.employees.map &:id end
      @participants << Employee.get_p(participants).map(&:id)
      @participants.flatten!.uniq
    else
      []
    end
  rescue
    return []
  end

  def active_bookings
    Meeting.where(booked_by: id).where("end_time > ?", Time.now)
  end

  def self.get_p(participants)
    e = arel_table[:name]
    p_arel = participants.collect{|p| e.matches("%#{p}%")}
    query = p_arel.shift
    p_arel.each do |x| query = query.or(x) end
    where(query)
  end
end

class Team < ActiveRecord::Base
  has_and_belongs_to_many :employees
  
  validates :name, uniqueness: true, presence: true
  def self.get_p(participants)
    e = arel_table[:name]
    p_arel = participants.collect{|p| e.matches("%#{p}%")}
    query = p_arel.shift
    p_arel.each do |x| query = query.or(x) end
    where(query)
  end
end

class Meeting < ActiveRecord::Base
  belongs_to :conference_room
  has_and_belongs_to_many :employees

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :conference_room, presence: true
  validates :booked_by, presence: true
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
  scope :booked, ->(start_time, end_time) {joins(:meetings).where("start_time <= ? and end_time >= ? ", start_time, end_time)}
  scope :available_rooms, ->(start_time, end_time) {joins(:meetings).where("(start_time >= ? and end_time >= ? ) or (start_time <= ? and end_time <= ? )", end_time, end_time)}

  def self.available(start_time, end_time)
    @booked_rooms = booked(start_time, end_time).pluck(:id)
    @booked_rooms.blank? ? ConferenceRoom.all : ConferenceRoom.where('id not in (?)', @booked_rooms)
  end
end
