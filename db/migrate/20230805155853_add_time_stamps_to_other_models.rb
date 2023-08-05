class AddTimeStampsToOtherModels < ActiveRecord::Migration[7.0]
  def change 
    add_timestamps(:admins)
    add_timestamps(:bookings)
    add_timestamps(:tentative_lineups)
    add_timestamps(:online_links)
    add_timestamps(:schedules)
  end
end
