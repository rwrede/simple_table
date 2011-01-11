module SimpleTable
  class Cell < Tag
    self.level = 3

    def initialize(parent, content = nil, options = {})
      super(parent, options)
      @content = content
      options[:colspan] = table.columns.size if options[:colspan] == :all
      yield self if block_given?
    end

    def content
      table.view && @content.is_a?(Symbol) ? table.view.t(@content) : @content
    end

    def render
      super(content, !content.html_safe?)
    end

    def tag_name
      parent.head? ? :th : :td
    end
  end
end
