class AddTestResultIdToAnswers < ActiveRecord::Migration
  def self.up
  	add_column :answers, :test_result_id, :integer
  end

  def self.down
  	remove_column :answers, :test_result_id
  end
end
