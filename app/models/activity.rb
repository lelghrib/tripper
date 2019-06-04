class Activity < ApplicationRecord
  belongs_to :city
  has_many :step_acivities
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
