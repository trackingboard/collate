module Collate
  module ActionViewExtension
    def filters_for_group record, group_key
      groups = record.model.collate_filters ||= {}

      group = groups[group_key] ||= {}

      filters = group[:filters] ||= []

      filters
    end

    def filters_for_groups record, group_keys
      group_keys.collect { |gk| filters_for_group record, gk }.flatten
    end

    def sorting_for record, opts={}
      sorters = record.model.collate_sorters ||= []

      opts[:name] ||= "order"

      render :partial => "collate/sort_select", locals: {sorters: sorters, opts: opts}
    end

    def filter_for filter
      render :partial => "collate/#{filter.component[:type]}_field", locals: {filter: filter}
    end
  end
end