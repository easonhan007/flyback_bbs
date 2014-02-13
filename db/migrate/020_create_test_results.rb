class CreateTestResults < ActiveRecord::Migration
  def self.up
    create_table :test_results do |t|
			t.string :content      
			t.boolean :passed
			t.belongs_to :account
			t.belongs_to :test
      t.timestamps
    end
  end

  def self.down
    drop_table :test_results
  end
end
