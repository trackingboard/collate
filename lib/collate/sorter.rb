module Collate
  class Sorter
    attr_accessor :field, :base_model_table_name, :label, :asc_label, :desc_label,
                  :field_select, :joins, :default

    def initialize(field, opt={})
      opt.each do |field, value|
        self.send("#{field}=", value)
      end

      self.field = field

      self.label ||= self.field.to_s.titleize
      self.asc_label ||= "#{label} ⬇"
      self.desc_label ||= "#{label} ⬆"

      self.field = "#{base_model_table_name}.#{field}" if field.is_a? Symbol

      self.joins ||= []
    end

  end
end
