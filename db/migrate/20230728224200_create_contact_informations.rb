class CreateContactInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_informations do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "mobile_number"
      t.string "email_address"
      t.bigint "booking_id"
      t.index ["booking_id"], name: "index_contact_information_on_booking_id"

      t.timestamps
    end
  end
end
