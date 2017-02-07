module Collate
  module ActionViewExtension
    def filters_for_group record, group_key
      groups = record.model.collate_filters ||= {}

      group = groups[group_key] ||= {}

      filters = group[:filters] ||= []

      filters
    end

    def sorting_for record
      sorters = record.model.collate_sorters ||= []

      render :partial => "collate/sort_select", locals: {sorters: sorters}
    end

    def filter_for filter
      render :partial => "collate/#{filter.component[:type]}_field", locals: {filter: filter}
    end
  end
end