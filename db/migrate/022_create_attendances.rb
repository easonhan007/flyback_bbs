class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :course_id
      t.integer :account_id
      t.integer :status
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :attendances
  end
end
