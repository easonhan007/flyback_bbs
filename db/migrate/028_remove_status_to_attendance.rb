class RemoveStatusToAttendance < ActiveRecord::Migration
  def self.up
    change_table :attendances do |t|
      t.remove :status
    end
  end

  def self.down
    change_table :attendances do |t|
      t.string :status
    end
  end
end
