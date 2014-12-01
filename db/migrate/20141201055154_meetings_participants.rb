class MeetingsParticipants < ActiveRecord::Migration
  def change
    create_table :meetings_participants, id: false do |t|
      t.integer :meeting_id
      t.integer :participant_id
    end
  end
end
