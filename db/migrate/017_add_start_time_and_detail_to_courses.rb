class AddStartTimeAndDetailToCourses < ActiveRecord::Migration
  def self.up
  	add_column :courses, :start_time, :date
  	add_column :courses, :detail, :text
  	add_column :courses, :active, :boolean, default: true
  end

  def self.down
  	remove_column :courses, :start_time
  	remove_column :courses, :detail
  	remove_column :courses, :active
  end
end
