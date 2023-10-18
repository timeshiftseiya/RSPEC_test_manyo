class AddColumnTasks < ActiveRecord::Migration[6.0]
  def change
    change_table :tasks do |t|
      t.date :deadline_on, :null => false
      t.integer :priority, :null => false
      t.integer :status, :null => false
    end
  end
end