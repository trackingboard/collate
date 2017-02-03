require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  setup do
    @bttf = Movie.where(name: "Back to the Future").first
    @jack_reacher = Movie.where(name: "Jack Reacher: Never Go Back").first
  end

  def test_that_we_can_get_movies_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

  def test_name_filter_on_movies
    filter = Collate::Filter.new(:name, base_model_table_name: "movies", operator: :ilike)
    get :index, filter.param_key => 'back'


    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_includes @movies, @jack_reacher
    assert_equal @movies.length, 2
  end

end
