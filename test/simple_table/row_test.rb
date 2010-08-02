require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class RowTest < Test::Unit::TestCase
    include TableTestHelper

    def test_render
      row = build_body_row
      row.cell 'foo'
      assert_html row.render, 'tr td', 'foo'
    end
  end
end
