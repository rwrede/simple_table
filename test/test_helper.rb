require 'rubygems'
require 'test/unit'
require 'bundler/setup'

Bundler.require(:default, :test)

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
    class Record
      attr_reader :id, :title
      def self.name; 'Record'; end
      def initialize(id, title); @id = id; @title = title; end
      def attribute_names; ['id', 'title']; end
    end

    def setup
      @scope = SimpleTable.options[:i18n_scope]
    end

    def teardown
      SimpleTable.options[:i18n_scope] = @scope
    end

    def t(*args)
      I18n.t(*args)
    end

    def record(id, title)
      Record.new(id, title)
    end

    def build_column(name, options = {})
      Column.new(nil, name, options)
    end

    def build_table(*columns)
      columns = [build_column('foo'), build_column('bar')] if columns.empty?
      table = Table.new(self, [record(1, 'foo'), record(2, 'bar')])
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
