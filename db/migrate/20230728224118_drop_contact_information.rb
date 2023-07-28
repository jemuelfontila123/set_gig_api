class DropContactInformation < ActiveRecord::Migration[7.0]
  def change
    drop_table :contact_information
  end
end
