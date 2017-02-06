module Collate
  module ActionViewExtension
    def filters_for_group record, group_key
      groups = record.model.collate_filters ||= {}

      group = groups[group_key]

      filters = group[:filters] ||= []
    end

    def filter_for filter
      case filter.component[:type]
      when 'checkbox'
        render :partial => "collate/checkbox_field", locals: {filter: filter}
      end
    end
  end
end