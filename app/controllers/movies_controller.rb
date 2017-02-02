class MoviesController < ApplicationController
  def index

    @movies = Movie.collate(params)
  end


end
