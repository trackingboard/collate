module Collate
  def self.database_type
    ActiveRecord::Base.connection.adapter_name.downcase.to_sym
  end
end
