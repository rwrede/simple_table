require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class HeadTest < Test::Unit::TestCase
    include TableTestHelper

    def test_adds_a_column_headers_row
      head = build_table.head
      assert_html head.render, 'thead' do
        assert_select 'tr th[scope=col]', 'foo'
        assert_select 'tr th[scope=col]', 'bar'
      end
    end

    def test_column_html_options
      head = build_table(build_column('foo', :class => 'foo')).head
      assert_html head.render, 'th[scope=col]', 'foo'
    end

    def test_translates_head_cell_content
      SimpleTable.options[:i18n_scope] = 'foo'
      head = build_table(build_column(:foo)).head
      assert_html head.render, 'th', 'translation missing: en, foo, strings, columns, foo'
    end

    def test_head_with_total_row
      head = build_table.head
      head.row { |r| r.cell "foo", :colspan => :all }
      assert_html head.render, 'thead tr th[colspan=2]', 'foo'
    end
  end
end
