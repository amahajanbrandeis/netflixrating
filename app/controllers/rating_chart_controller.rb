class RatingChartController < ApplicationController
  def show
    @movie_rating = MovieRating.all.order('rating DESC')
  end
end
