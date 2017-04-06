ActiveRecord::Schema.define do
  self.verbose = false

  create_table :movies, :force => true do |t|
    t.string      :name
    t.boolean     :good_movie
    t.date        :release_date
    t.text        :synopsis
    t.integer     :user_rating
    t.references  :director
    t.string      :mpaa_rating
  end

  create_table :genres_movies, :force => true do |t|
    t.references :movie
    t.references :genre
  end

  create_table :genres, :force => true do |t|
    t.string :name
  end

  create_table :directors, :force => true do |t|
    t.string :name
  end

  create_table :actors, :force => true do |t|
    t.string     :name
    t.string     :aka
    t.integer    :popularity

    if ENV["RAILS_ENV"] == 'mysql'
      t.json     :personal_data
    else
      t.jsonb    :personal_data
    end

    t.integer    :cool_projects
  end

  create_table :characters, :force => true do |t|
    t.string     :name
    t.references :movie
    t.references :actor
    t.integer    :order
  end

end
