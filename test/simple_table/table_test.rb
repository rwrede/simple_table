require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class TableTest < Test::Unit::TestCase
    include TableTestHelper

    def test_render_basic
      table = Table.new(nil, [record(1, 'a'), record(2, 'b')])do |table|
        table.column('a'); table.column('b')
        table.row { |row, record| row.cell(record.title); row.cell(record.title) }
      end

      assert_html table.render, 'table[id=records][class=records list]' do
        assert_select 'thead tr th[scope=col]', 'a'
        assert_select 'tbody tr td', 'a'
        assert_select 'tbody tr[class=alternate] td', 'b'
      end
    end

    def test_render_calling_column_and_cell_shortcuts
      table = Table.new(nil, [record(1, 'a'), record(2, 'b')]) do |table|
        table.column 'a', 'b'
        table.row { |row, record| row.cell record.title, record.title }
      end

      assert_html table.render, 'table[id=records][class=records list]' do
        assert_select 'thead tr th[scope=col]', 'a'
        assert_select 'tbody tr td', 'a'
        assert_select 'tbody tr[class=alternate] td', 'b'
      end
    end

    def test_block_can_access_view_helpers_and_instance_variables
      @foo = 'foo'
      table = Table.new(nil, [record(1, 'a')]) do |table|
        table.column 'a'
        table.row { |row, record, index| row.cell @foo + bar }
      end
      html = ''
      assert_nothing_raised { html = table.render }
      assert_match %r(foobar), html
    end

    def test_column_html_class_inherits_to_tbody_cells
      table = Table.new(nil, [record(1, 'a')])do |table|
        table.column 'a', :class => 'foo'
        table.row { |row, record, index| row.cell 'bar' }
      end
      assert_html table.render, 'tbody tr td[class=foo]', 'bar'
    end

    def test_table_header_cells_get_a_default_header_id
      table = Table.new(nil, %w(Title))do |table|
        table.column 'Title'
       table.row { |row, record, index| row.cell 'some record title' }
      end
      assert_html table.render, 'thead tr th[id=title_header]', 'Title'
    end

    def test_table_header_cells_default_header_id_can_be_overriden_by_adding_an_alternate_id_key_in_the_options_hash
      table = Table.new(nil, %w(Title))do |table|
        table.column 'Title', :id => 'some_other_id'
       table.row { |row, record, index| row.cell 'some record title' }
      end
      assert_html table.render, 'thead tr th[id=some_other_id]', 'Title'
    end

    def test_table_data_cells_get_a_default_headers_attr_representing_their_header_cells
      table = Table.new(nil, %w(Title))do |table|
        table.column 'Title'
       table.row do |row, record, index|
         row.cell 'some record title'
       end
      end
      assert_html table.render, 'tbody tr td[headers=title_header]', 'some record title'
    end

    def test_table_data_cells_default_headers_attr_can_be_overridden_by_adding_an_alternate_headers_key_in_the_options_hash
      table = Table.new(nil, %w(Title))do |table|
        table.column 'Title'
       table.row { |row, record, index| row.cell 'some record title', :headers => 'some_other_header' }
      end
      assert_html table.render, 'tbody tr td[headers=some_other_header title_header]', 'some record title'
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
