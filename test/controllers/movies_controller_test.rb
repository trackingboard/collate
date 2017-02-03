require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  setup do
    @bttf = Movie.where(name: "Back to the Future").limit(1).first
    @tm = Movie.where(name: "Twelve Monkeys").limit(1).first
    @jack_reacher = Movie.where(name: "Jack Reacher: Never Go Back").limit(1).first
    @scifi = Genre.where(name: "Science Fiction").limit(1).first
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

  def test_name_eq_filter_on_movies
    filter = Collate::Filter.new(:name, base_model_table_name: "movies")
    get :index, filter.param_key => "Back to the Future"

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 1
  end

  def test_get_all_scifi_movies
    filter = Collate::Filter.new('genres.id', base_model_table_name: "movies", operator: :contains, field_transformations: [:array_agg], value_transformations: [:join])

    get :index, filter.param_key => [@scifi.id]

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 2
  end

  def test_get_non_scifi_movies
    filter = Collate::Filter.new('genres.id', base_model_table_name: "movies", operator: :&, not: true, field_transformations: [:array_agg], value_transformations: [:join])

    get :index, filter.param_key => [@scifi.id]

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @jack_reacher
    assert_equal @movies.length, 1
  end

  def test_boolean_filter
    filter = Collate::Filter.new(:good_movie, base_model_table_name: "movies", operator: :present?)

    get :index, filter.param_key => true

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_includes @movies, @tm
    assert_equal @movies.length, 2
  end

end
