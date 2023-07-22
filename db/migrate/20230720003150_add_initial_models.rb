class AddInitialModels < ActiveRecord::Migration[7.0]
  def change 

    create_table :admins do |admin|
      admin.string :username, index: { unique: true, name: 'unique_username'}
      admin.string :role_id, array: true, default: [0]
      admin.string :password_digest
    end 

    create_table :schedules do |schedule| 
      schedule.datetime :start_time 
      schedule.datetime :end_time 
      schedule.boolean :availability, default: true 
    end 

    create_table :bookings do |b| 
      b.string :name
      b.string :description
      b.text :previous_events
      b.references :schedule, index: true, foreign_key: true 
      b.integer :status, default: 0 
      b.integer :booking_type, default: 0
    end 

    create_table :tentative_lineups do |t| 
      t.string :band_name 
      t.string :genres, array: true, default: []  
      t.references :booking, index: true, foreign_key: true
    end 


    create_table :contact_information do |c| 
      c.string :first_name 
      c.string :last_name
      c.string :mobile_number 
      c.string :email_address, index: { unique: true, name: 'unique_email_address'}
      c.references :booking, index: true, foreign_key: true
    end
    
    create_table :online_links do |o|
      o.string :link_type
      o.text :url 
      o.references :booking, index: true, foreign_key: true 
    end




  end
end
