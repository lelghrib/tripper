class Trip < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy
  validates :departure_city, :arrival_city, :start_date, :end_date, :criteria, presence: true
end
