# Creating cities
array_of_cities = %w(Florence Rome Naples Bologne Bari Positano Anzio Piombino)
array_of_cities.each do |city|
  City.create!(country: "Italy", name: city)
end
# Cities created
