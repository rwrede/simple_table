require 'simple_table/tag'
require 'simple_table/cell'
require 'simple_table/row'
require 'simple_table/rows'
require 'simple_table/body'
require 'simple_table/head'
require 'simple_table/foot'
require 'simple_table/column'
require 'simple_table/table'


module SimpleTable
  mattr_accessor :options
  self.options = {
    :alternate_rows => true,
    :i18n_scope => nil
  }

  def table_for(collection = [], options = {}, &block)
    html = Table.new(self, collection, options, &block).render.html_safe
    concat html
  end
end
