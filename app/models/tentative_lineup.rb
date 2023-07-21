class TentativeLineup < ApplicationRecord
    validates :band_name, presence: true 

    belongs_to :booking
end