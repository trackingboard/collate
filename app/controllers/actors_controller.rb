class ActorsController < ApplicationController
  def index

    @actors = Actor.collate(params)
  end


end
