class AddPasswordAndContactType < ActiveRecord::Migration[7.0]
  def change 
    add_column :contact_informations, :contact_type, :integer, default: 0
    add_column :contact_informations, :password_digest, :string
  end
end
