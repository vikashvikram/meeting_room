class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.references :conference_room, index: true
      t.datetime :start_time, null:false
      t.datetime :end_time, null:false
    
      t.timestamps
    end
  end
end
