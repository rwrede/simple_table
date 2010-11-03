require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class BodyTest < Test::Unit::TestCase
    include TableTestHelper

    def test_render
      body = build_table.body
      body.row { |row, record| row.cell(record.title) }
      assert_html body.render, 'tbody' do
        assert_select 'tr td', 'foo'
        assert_select 'tr[class=alternate] td', 'bar'
      end
    end

    def test_cell_html_options
      body = build_table.body
      body.row { |row, record| row.cell(record.title, :class => 'baz') }
      assert_html body.render, 'td[class=baz foo]', 'foo'
    end
  end
end
