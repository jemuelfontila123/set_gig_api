class AddLockSchedule < ActiveRecord::Migration[7.0]
  def change 
    add_column :schedules, :locked_token, :string 
    add_column :schedules, :locked_at, :datetime
  end
end
