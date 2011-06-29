require 'action_view'
require 'active_record'
require 'active_support/core_ext/module/attribute_accessors'

module SimpleTable
  autoload :Tag,    'simple_table/tag'
  autoload :Cell,   'simple_table/cell'
  autoload :Row,    'simple_table/row'
  autoload :Rows,   'simple_table/rows'
  autoload :Body,   'simple_table/body'
  autoload :Head,   'simple_table/head'
  autoload :Foot,   'simple_table/foot'
  autoload :Column, 'simple_table/column'
  autoload :Table,  'simple_table/table'

  mattr_accessor :options
  self.options = {
    :alternate_rows => true,
    :i18n_scope     => nil
  }

  def table_for(collection = [], options = {}, &block)
    Table.new(self, collection, options, &block).render.html_safe
  end
end

ActionView::Base.send(:include, SimpleTable)
