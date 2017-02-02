require 'test_helper'

class MoviesControllerTest < ActionController::TestCase

  def test_that_we_can_get_movies_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

end
