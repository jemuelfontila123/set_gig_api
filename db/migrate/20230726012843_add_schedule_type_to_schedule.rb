class AddScheduleTypeToSchedule < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :schedule_type, :integer, default: 0
  end
end
