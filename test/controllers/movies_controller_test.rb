require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  setup do
    @bttf = Movie.where(name: "Back to the Future").limit(1).first
    @tm = Movie.where(name: "Twelve Monkeys").limit(1).first
    @jack_reacher = Movie.where(name: "Jack Reacher: Never Go Back").limit(1).first
    @scifi = Genre.where(name: "Science Fiction").limit(1).first
    @scifi_hash = { id: 2, text: "Science Fiction" }
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
    filter = Collate::Filter.new(:name, base_model_table_name: "movies", field_transformations: [:downcase, :pizza])
    get :index, filter.param_key => "back to the future"

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 1
  end

  def test_get_all_scifi_movies
    filter = Collate::Filter.new('genres.id', base_model_table_name: "movies", operator: :contains, component: {load_records: true}, field_transformations: [:array_agg], value_transformations: [:join])

    get :index, filter.param_key => [@scifi.id]

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 2

    Movie.collate_filters.each do |group_key, group|
      group[:filters].each do |f|
        if f.param_key == filter.param_key
          assert_includes f.component[:values], @scifi_hash
          assert_equal f.component[:values].length, 1
        end
      end
    end
  end

  def test_get_non_scifi_movies
    filter = Collate::Filter.new('select_genres.id', base_model_table_name: "movies", joins: [:genres], joins_prefix: 'select_', operator: :&, not: true, field_transformations: [:array_agg], value_transformations: [:join])

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

  def test_date_field_transformations
    filter = Collate::Filter.new(:release_date, base_model_table_name: "movies", operator: :ge, field_transformations: [[:date_difference, "date '2017-01-01'"], [:date_part, 'year']])

    get :index, filter.param_key => 2

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @jack_reacher
    assert_equal @movies.length, 1
  end

  def test_split_field_transformation
    filter = Collate::Filter.new(:synopsis, base_model_table_name: "movies", label: 'Keywords', operator: :contains, component: {tags: true}, field_transformations: [:downcase, [:split, ' ']], value_transformations: [:join, :downcase])

    get :index, filter.param_key => ['biodiesel', 'listicle']

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 1
  end

  def test_le_operator
    filter = Collate::Filter.new(:user_rating, base_model_table_name: "movies", operator: :le)

    get :index, filter.param_key => 6

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @jack_reacher
    assert_equal @movies.length, 1
  end

  def test_array_length
    filter = Collate::Filter.new(:synopsis, base_model_table_name: "movies", operator: :le, field_transformations: [[:split, ' '], [:array_length, 1]])

    get :index, filter.param_key => 11

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @tm
    assert_equal @movies.length, 1
  end

  def test_null_operator
    filter = Collate::Filter.new(:user_rating, base_model_table_name: "movies", operator: :null)

    get :index, filter.param_key => 'pizza'

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 1
  end

  def test_undefined_operator
    filter = Collate::Filter.new(:name, base_model_table_name: "movies", operator: :pizza)

    get :index, filter.param_key => 'party'

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_equal @movies.length, Movie.count
  end

  def test_in_operator
    filter = Collate::Filter.new('genres.id', base_model_table_name: "movies", value_transformations: [:pizza])

    get :index, filter.param_key => [@scifi.id]

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 2
  end

  def test_undefined_value_transformation
    filter = Collate::Filter.new('genres.id', base_model_table_name: "movies", value_transformations: [:pizza])

    get :index, filter.param_key => [@scifi.id]

    @movies = assigns(:movies)

    assert_not_nil @movies
    assert_includes @movies, @bttf
    assert_equal @movies.length, 2
  end
end
