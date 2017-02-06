module Collate
  module ActionViewExtension
    def filters_for_group group_key
      puts controller.inspect
    end
  end
end