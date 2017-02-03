class Movie < ActiveRecord::Base
  has_and_belongs_to_many :genres

  collate_group :basic_information, default_open: true do
    collate_on :name
    collate_on :name, operator: :ilike
    collate_on 'genres.id', operator: :contains, field_transformations: [:array_agg], value_transformations: [:join]
    collate_on 'genres.id', operator: :&, not: true, field_transformations: [:array_agg], value_transformations: [:join]
    collate_on :good_movie, operator: :present?
  end
end