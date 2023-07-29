class TentativeLineup < ApplicationRecord
  include ActiveModel::Validations 
  
  validates_with Validators::TentativeLineupValidator 
  validates :band_name, presence: true 
  validates :genres, presence: true
  
  belongs_to :booking
end