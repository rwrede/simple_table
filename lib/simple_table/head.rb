module SimpleTable
  class Head < Rows
    self.level = 1
    self.tag_name = :thead

    def render(*args)
      build
      super(rows.map { |row| row.render(*args) })
    end

    protected

      def build
        row = Row.new(self, options)
        table.columns.each do |column|
          row.cell(column.content, column.options.reverse_merge(:scope => 'col'))
        end
        rows << row
      end
  end
end
