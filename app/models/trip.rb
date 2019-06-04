class Trip < ApplicationRecord
  belongs_to :user, optional: true
  has_many :steps, dependent: :destroy
  validates :departure_city, :arrival_city, :start_date, :end_date, presence: true
end
