require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class TagTest < Test::Unit::TestCase
    def test_render
      tag = Tag.new
      tag.tag_name = 'foo'
      html = tag.render { |html| html << 'bar' }
      assert_html html, 'foo', 'bar'
    end
  end
end