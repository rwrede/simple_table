require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class CellTest < Test::Unit::TestCase
    def test_render
      html = Cell.new(Row.new(Table.new), 'foo').render
      assert_html html, 'td', 'foo'
    end

    def test_picks_th_when_contained_in_head
      html = Cell.new(Row.new(Head.new(Table.new)), 'foo').render
      assert_html html, 'th', 'foo'
    end

    def test_cell_contents_are_escaped
      html = Cell.new(Row.new(Table.new), '<script>').render
      assert_html html, 'td', '&lt;script&gt;'

      html = Cell.new(Row.new(Head.new(Table.new)), '<script>').render
      assert_html html, 'th', '&lt;script&gt;'
    end
  end
end
