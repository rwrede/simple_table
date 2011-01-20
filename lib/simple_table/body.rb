module SimpleTable
  class Body < Rows
    self.tag_name = :tbody

    def render
      build
      super(''.tap do |html|
        table.collection.each_with_index do |record, ix|
          html << rows.map { |row| row.render(record, options_for_record(record, ix, options)) }.join
        end
      end)
    end

    protected

      def build
        row do |row, record|
          row.cell *table.columns.map { |column| record.send(column.attribute_name) }
        end if @rows.empty?
      end

      def options_for_record(record, ix, options = {})
        options.dup.tap do |options|
          options[:id] = "#{table.collection_name.singularize}_#{record.id}"
          add_class!(options, 'alternate') if ix % 2 == 1
        end
      end
  end
end
