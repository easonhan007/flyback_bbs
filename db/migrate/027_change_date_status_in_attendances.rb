class ChangeDateStatusInAttendances < ActiveRecord::Migration
  def self.up
    change_column :attendances, :status, :string
  end

  def self.down
  end
end
