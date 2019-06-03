class Step < ApplicationRecord
  belongs_to :city
  belongs_to :trip
  has_many :activities, through: :step_acivities
  has_many :step_acivities, dependent: :destroy
end
