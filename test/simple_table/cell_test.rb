require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class CellTest < Test::Unit::TestCase
    def test_render
      assert_html render_table_cell('foo'), 'td', 'foo'
    end

    def test_picks_th_when_contained_in_head
      assert_html render_head_cell('foo'), 'th', 'foo'
    end

    def test_cell_contents_are_xss_protected
      assert_html render_table_cell('<script>'), 'td', '&lt;script&gt;'
      assert_html render_head_cell('<script>'),  'th', '&lt;script&gt;'
    end

    protected

      def render_table_cell(content)
        Cell.new(Row.new(Table.new), content).render
      end

      def render_head_cell(content)
        Cell.new(Row.new(Head.new(Table.new)), content).render
      end
  end
end
