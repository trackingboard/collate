ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string :name
    t.datetime :birthday

    t.timestamps null: false
  end

  create_table :movies, :force => true do |t|
    t.string :name

    t.timestamps null: false
  end

end