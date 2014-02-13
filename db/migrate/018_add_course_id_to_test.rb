class AddCourseIdToTest < ActiveRecord::Migration
  def self.up
  	add_column :tests, :course_id, :integer
  end

  def self.down
  	remove_column :tests, :course_id
  end
end
