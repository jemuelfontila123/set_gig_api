class RemoveUniqueIndexFromEmailInContactInformations < ActiveRecord::Migration[7.0]
  def change
    remove_index :contact_information, column: :email_address, name: "unique_email_address", if_exists: true
  end
end
