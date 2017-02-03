require 'test_helper'

class ComponentTest < ActionController::TestCase
  setup do
    @action_hash = {:id=>1, :text=>"Action"}
    @scifi_hash = {:id=>2, :text=>"Science Fiction"}
  end

  def test_that_component_values_set_from_model
    filter = Collate::Filter.new('genres.id', base_model_table_name: "movies", operator: :&, not: true, component: {type: 'select', multiple: true, values: Genre}, field_transformations: [:array_agg], value_transformations: [:join])

    assert_includes filter.component[:values], @scifi_hash
    assert_includes filter.component[:values], @action_hash

    assert_equal filter.component[:values].length, 2
  end

end
