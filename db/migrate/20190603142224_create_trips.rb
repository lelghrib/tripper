class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.references :user, foreign_key: true
      t.string :departure_city
      t.string :arrival_city
      t.datetime :start_date
      t.datetime :end_date
      t.json :criteria

      t.timestamps
    end
  end
end
