require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class FootTest < Test::Unit::TestCase
    include TableTestHelper

    def test_foot
      table = Table.new(self, [record(1, 'foo')]) do |t|
        t.foot(:id => 'foot', :class => :foot) do |f|
          f.row :id => 'row', :class => :row do |r, item|
            r.cell 'foo', :id => 'cell', :class => :cell
          end
        end
      end
      assert_html table.render, 'tfoot#foot.foot tr#row.row td#cell.cell', 'foo'
    end
  end
end

