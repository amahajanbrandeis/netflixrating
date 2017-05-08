class CreateMovieRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :movie_ratings do |t|
      t.string :name
      t.integer :rating

      t.timestamps
    end
  end
end
