class Actor < ActiveRecord::Base
  has_many :characters

  collate_on 'coworker_characters.actor_id', joins_prefix: ['worked_with_', 'coworker_'], joins: [:characters =>[:movie => [:characters]]], component: {load_records: true}

  collate_on :personal_data, operator: :contains, or: true, value_transformations: [[:to_json, 'ss_num']]

  collate_sort :popularity, nulls_last: true
  collate_sort 'characters.order', joins: [:characters], nulls_first: true
  collate_sort :cool_projects, default: 'asc'
end
