module Collate
  class Filter
    OPERATORS = [:eq, :ilike, :in, :le, :ge, :null, :contains, :present?, :&]

    FIELD_TRANSFORMATIONS = [:date_difference, :date_part, :array_agg, :downcase, :split, :array_length]
    AGGREGATE_TRANSFORMATIONS = [:array_agg]
    VALUE_TRANSFORMATIONS = [:join, :downcase, :string_part, :to_json]

    attr_accessor :field, :operator, :base_model_table_name, :field_transformations, :label,
                  :component, :joins, :value_transformations, :grouping, :html_id, :having,
                  :joins_prefix, :not, :or

    def initialize(field, opt={})
      opt.each do |f, value|
        self.send("#{f}=", value)
      end

      self.component ||= {}

      self.field = field
      self.label ||= field.to_s.titleize
      self.operator ||= if field.to_s.last(3) == '.id' || field.to_s.last(3) == '_id'
        :in
      elsif self.component[:type] == 'checkboxgroup'
        :in
      else
        :eq
      end
      self.field = "#{base_model_table_name}.#{field}" if field.is_a? Symbol
      self.field_transformations ||= {}
      self.value_transformations ||= {}

      self.html_id ||= param_key.gsub('{','').gsub('}','').gsub('.','_')

      field_parts = self.field.to_s.partition('.')
      table_name = field_parts[0]
      field_selector = field_parts[2]

      self.component = if self.operator == :in
        self.component.reverse_merge({type: 'select', multiple: true, values: []})
      elsif self.operator == :null || self.operator == :present?
        self.component.reverse_merge({type: 'checkbox'})
      elsif self.component[:tags]
        self.component.reverse_merge({type: 'select', multiple: true})
      else
        self.component.reverse_merge({type: 'string'})
      end

      if self.component[:load_records]
        model_name = if field_selector.last(3) == '_id'
          field_selector.chomp(field_selector.last(3))
        elsif self.field.to_s.last(3) == '.id'
          table_name.singularize
        else
          table_name.singularize
        end

        self.component[:load_record_model] ||= model_name.titleize
        self.component[:load_record_field] ||= "id"
        self.component[:load_record_route] ||= "/#{model_name.pluralize}.json"
      end

      self.joins ||= if table_name != base_model_table_name
        join_name = table_name.to_sym
        base_model_table_name.singularize.titleize.constantize.reflect_on_all_associations.each do |assoc|

          join_name = assoc.name if assoc.plural_name == table_name
        end

        [join_name.to_sym]
      end
      self.joins_prefix = [self.joins_prefix] if self.joins_prefix.is_a? String

      if !opt.has_key?(:having) && (field_transformations.to_a.flatten & AGGREGATE_TRANSFORMATIONS).any?
        self.having = true
      end

      if self.value_transformations.empty? && self.operator == :ilike
        self.value_transformations = [:string_part]
      end

      self.grouping ||= if self.having
        "#{base_model_table_name}.id"
      end

      if self.component[:values]
        self.component[:values] = if self.component[:values].is_a?(Array) && self.component[:values].all? { |item| item.is_a? String }
          self.component[:values].map { |s| {id: s, text: s.titleize} }
        elsif self.component[:values].is_a?(Array) && self.component[:values].all? { |item| item.is_a? Symbol }
          self.component[:values].map { |s| {id: s, text: s.to_s.titleize} }
        elsif self.component[:values].respond_to?(:<) && self.component[:values] < ActiveRecord::Base
          self.component[:values].table_exists? ? self.component[:values].all.map { |m| {id: m.id, text: m.name} } : []
        else
          self.component[:values]
        end
      elsif component[:tags]
        self.component[:values] = []
      end
    end

    def param_key
      key = ""
      field_transformations.each do |ft|
        transformation = ft
        transformation = ft[0] if !transformation.is_a? Symbol
        key += FIELD_TRANSFORMATIONS.index(transformation).to_s
      end
      key += OPERATORS.index(operator).to_s
      value_transformations.each do |vt|
        transformation = vt
        transformation = vt[0] if !transformation.is_a? Symbol
        key += VALUE_TRANSFORMATIONS.index(transformation).to_s
      end

      "{#{key}}#{field}"
    end
  end
end
