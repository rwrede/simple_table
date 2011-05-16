module SimpleTable
  class Table < Tag
    self.level = 0
    self.tag_name = :table

    attr_reader :view, :body, :head, :foot, :collection, :columns

    def initialize(view = nil, collection = [], options = {})
      @view = view
      @collection = collection
      @columns = []
      @collection_name = options.delete(:collection_name).to_s if options.key?(:collection_name)

      super(nil, options.reverse_merge(:id => collection_name, :class => "#{collection_name} list"))
    end

    ['head', 'body', 'foot'].each do |name|
      class_eval <<-code
        def #{name}(*args, &block)                                # def head(*args, &block)
          @#{name} ||= #{name.classify}.new(self, *args, &block)  #   @head ||= Head.new(self, *args, &block)
        end                                                       # end
      code
    end

    def column(*names)
      options = names.last.is_a?(Hash) ? names.pop : {}
      names.each { |name| columns << Column.new(self, name, options) }
    end

    # Usage:
    #   table_for collection do |t|
    #    t.empty :div, :class => 'no-items' do
    #      "everything sold out, mam"
    #    end
    #   end
    def empty(*args, &block)
      @empty ||= (args << block).compact
    end

    def row(*args, &block)
      body.row(*args, &block)
    end

    def collection_class
      collection.first.class
    end

    def collection_name
      @collection_name ||= collection_class.name.tableize.gsub('/', '_').gsub('rails_', '')
    end

    def render
      (collection.empty? && empty) ? render_empty : begin
        column(*collection_attribute_names) if columns.empty?
        super do |html|
          html << head.render
          html << body.render
          html << foot.render if foot && !foot.empty?
        end.gsub(/\n\s*\n/, "\n")
      end
    end

    def render_empty
      empty.insert(1, empty.pop.call) if empty.last.respond_to?(:call)
      empty.empty? ? '' : content_tag(*empty)
    end

    protected

      def collection_attribute_names
        record = collection.first
        names = record.respond_to?(:attribute_names) ? record.attribute_names : []
        names.map(&:titleize)
      end
  end
end
