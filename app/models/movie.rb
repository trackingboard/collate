class Movie < ActiveRecord::Base
  collate_group :basic_information, default_open: true do
    collate_on :name, operator: :ilike
  end
end