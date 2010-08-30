require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class TableTest < Test::Unit::TestCase
    def test_render_basic
      table = Table.new(nil, %w(a b))do |table|
        table.column('a'); table.column('b')
        table.row { |row, record| row.cell(record); row.cell(record) }
      end

      assert_html table.render, 'table[id=strings][class=strings list]' do
        assert_select 'thead tr th[scope=col]', 'a'
        assert_select 'tbody tr td', 'a'
        assert_select 'tbody tr[class=alternate] td', 'b'
      end
    end

    def test_render_calling_column_and_cell_shortcuts
      table = Table.new(nil, %w(a b)) do |table|
        table.column 'a', 'b'
        table.row { |row, record| row.cell record, record }
      end

      assert_html table.render, 'table[id=strings][class=strings list]' do
        assert_select 'thead tr th[scope=col]', 'a'
        assert_select 'tbody tr td', 'a'
        assert_select 'tbody tr[class=alternate] td', 'b'
      end
    end

    def test_block_can_access_view_helpers_and_instance_variables
      @foo = 'foo'
      table = Table.new(nil, %w(a)) do |table|
        table.column 'a'
        table.row { |row, record, index| row.cell @foo + bar }
      end
      html = ''
      assert_nothing_raised { html = table.render }
      assert_match %r(foobar), html
    end

    def test_column_html_class_inherits_to_tbody_cells
      table = Table.new(nil, %w(a))do |table|
        table.column 'a', :class => 'foo'
        table.row { |row, record, index| row.cell 'bar' }
      end
      assert_html table.render, 'tbody tr td[class=foo]', 'bar'
    end

    class ::TestModel
      attr_accessor :id

      def initialize(attributes={})
        @id = attributes[:id]
      end
    end
    
    def test_row_id
      test_collection = []
      test_collection << TestModel.new(:id => 1)
      test_collection << TestModel.new(:id => 2)
      table = Table.new(nil, test_collection)
      assert_html table.render, 'tbody tr[id=test_model_1]'
    end

    def test_table_collection_name
      assert_equal 'objects', Table.new(nil, [Object.new]).collection_name
    end

    protected

      def bar
        'bar'
      end
  end
end