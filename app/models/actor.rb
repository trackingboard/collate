class Actor < ActiveRecord::Base
  has_many :characters

  collate_on 'coworker_characters.actor_id', joins_prefix: ['worked_with_', 'coworker_'], joins: [:characters =>[:movie => [:characters]]], component: {load_records: true}
end
