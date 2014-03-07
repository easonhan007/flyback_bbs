class AddAttendanceStatusToAttendance < ActiveRecord::Migration
  def self.up
    change_table :attendances do |t|
      t.string :attendance_status
    end
  end

  def self.down
    change_table :attendances do |t|
      t.remove :attendance_status
    end
  end
end
