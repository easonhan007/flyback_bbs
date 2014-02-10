class CreateSelectedCourses < ActiveRecord::Migration
  def self.up
    create_table :selected_courses do |t|
			t.belongs_to :account     
			t.belongs_to :course     
			t.boolean :paid, default: false
      t.timestamps
    end
  end

  def self.down
    drop_table :selected_courses
  end
end
