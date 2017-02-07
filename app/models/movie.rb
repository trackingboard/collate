class Movie < ActiveRecord::Base
  RATINGS = [:R, :PG13]

  has_and_belongs_to_many :genres
  has_many :characters

  collate_group :basic_information, default_open: true do
    collate_on :name, field_transformations: [:downcase, :pizza]
    collate_on :name, operator: :ilike
    collate_on 'genres.id', operator: :contains, component: {load_records: true}, field_transformations: [:array_agg], value_transformations: [[:join, ', '], :as_array]
    collate_on 'select_genres.id', joins: [:genres], joins_prefix: 'select_', operator: :&, not: true, field_transformations: [:array_agg], value_transformations: [[:join, ', '], :as_array]
    collate_on :good_movie, operator: :present?
    collate_on :release_date, operator: :ge, field_transformations: [[:date_difference, "date '2017-01-01'"], [:date_part, 'year']]
    collate_on :synopsis, label: 'Keywords', operator: :contains, component: {tags: true}, field_transformations: [:downcase, [:split, ' ']], value_transformations: [[:join, ', '], :as_array, :downcase]
    collate_on :user_rating, operator: :le
    collate_on :synopsis, operator: :le, field_transformations: [[:split, ' '], [:array_length, 1]]
    collate_on :user_rating, operator: :null
    collate_on :name, operator: :pizza
    collate_on 'genres.id', value_transformations: [:pizza]
    collate_on :director_id, component: {load_records: true, type: 'checkboxgroup'}
    collate_on :mpaa_rating, component: {type: 'checkboxgroup', values: Movie::RATINGS}
  end
end
