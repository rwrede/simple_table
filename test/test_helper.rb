$: << File.dirname(__FILE__) + "/../lib"

require 'rubygems'
require 'test/unit'
require 'simple_table'
require 'gem_patching'
require 'active_support'
require 'action_view'
require 'action_dispatch/testing/assertions'

class Test::Unit::TestCase
  include ActionDispatch::Assertions::SelectorAssertions

  def assert_html(html, *args, &block)
    assert_select(HTML::Document.new(html).root, *args, &block)
  end
end

module SimpleTable
  module TableTestHelper
    def setup
      @scope = SimpleTable.options[:i18n_scope]
    end

    def teardown
      SimpleTable.options[:i18n_scope] = @scope
    end

    def build_column(name, options = {})
      Column.new(nil, name, options)
    end

    def build_table(*columns)
      columns = [build_column('foo'), build_column('bar')] if columns.empty?
      table = Table.new(nil, %w(foo bar))
      table.instance_variable_set(:@columns, columns)
      columns.each { |column| column.instance_variable_set(:@table, table) }
      table
    end

    def build_body(*columns)
      Body.new(build_table(*columns))
    end

    def build_body_row(*columns)
      Row.new(build_body(*columns))
    end
  end
end
