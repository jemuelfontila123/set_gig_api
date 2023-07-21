class Booking < ApplicationRecord 

    belongs_to :schedule

    enum :booking_type { production: 0, band: 1}
    enum :status {pending: 0, denied: 1, approved: 2}
end