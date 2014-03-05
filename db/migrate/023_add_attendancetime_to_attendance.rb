class AddAttendancetimeToAttendance < ActiveRecord::Migration
  def self.up
    change_table :attendances do |t|
      t.time :attendance_time
    end
  end

  def self.down
    change_table :attendances do |t|
      t.remove :attendance_time
    end
  end
end
