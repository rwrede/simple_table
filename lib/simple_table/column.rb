module SimpleTable
  class Column
    attr_reader :name, :table, :options

    def initialize(table, name, options = {})
      @table = table
      @name = name
      @value = options.delete(:value)
      @options = options.dup || {}
      @options[:class] ||= name
      @options[:id] ||= "#{name.to_s.downcase}_header" if name
    end

    def content
      name.is_a?(Symbol) ? translate(name) : name
    end

    def translate(content)
      table.view.t(:".columns.#{name}", :default => '')
    end

    def attribute_name
      name.to_s.underscore
    end
  end
end
