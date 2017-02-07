require 'test_helper'

class ActorsControllerTest < ActionController::TestCase
  setup do
    @nick = Actor.find_by(name: "Nick")
    @colleen = Actor.find_by(name: "Colleen")
  end

  def test_actors_have_worked_with_actors
    filter = Collate::Filter.new('coworker_characters.actor_id', base_model_table_name: "actors", joins_prefix: ['worked_with_', 'coworker_'], joins: [:characters =>[:movies => [:characters]]], component: {load_records: true})

    get :index, filter.param_key => [@colleen.id]

    @actors = assigns(:actors)

    assert_not_nil @actors
    assert_includes @actors, @nick
    assert_includes @actors, @colleen
    assert_equal @actors.length, 2
  end

  def test_actor_popularity_sorting
    get :index, {order: 'actors.popularity DESC'}

    @actors = assigns(:actors)

    assert_not_nil @actors

    assert_equal @actors[0], @colleen
    assert_equal @actors[1], @nick

    assert_equal @actors.length, 3
  end
end
