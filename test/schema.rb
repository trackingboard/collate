ActiveRecord::Schema.define do
  self.verbose = false

  create_table :movies, :force => true do |t|
    t.string      :name
    t.boolean     :good_movie
    t.date        :release_date
    t.text        :synopsis
    t.integer     :user_rating
    t.references  :director
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

end
