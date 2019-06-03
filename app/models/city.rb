class City < ApplicationRecord
  has_many :steps
  has_many :activities
end
