require File.dirname(__FILE__) + "/../test_helper"

module SimpleTable
  class Record
    attr_reader :id, :title
    def initialize(id, title); @id = id; @title = title; end
    def attribute_names; ['id', 'title']; end
  end

  class RenderTest < Test::Unit::TestCase
    attr_reader :view

    def setup
      articles = [Record.new(1, 'foo'), Record.new(2, 'bar'), Record.new(3, 'baz')]

      @view = ActionView::Base.new([File.dirname(__FILE__) + '/../fixtures/templates'], { :articles => articles })
      @view.extend(SimpleTable)

      I18n.backend.store_translations(:en, :columns => { :id => 'ID', :title => 'Title' })
    end

    def test_render_simple
      html = view.render(:file => 'table_simple')
      assert_html html, 'table[id=simple_table_records][class=simple_table_records list]' do
        assert_select 'thead tr' do
          assert_select 'th[scope=col]', 'ID'
          assert_select 'th[scope=col]', 'Title'
        end
        assert_select 'tbody' do
          assert_select 'tr:not([class=alternate])' do
            assert_select 'td', '1'
            assert_select 'td', 'foo'
          end
          assert_select 'tr[class=alternate]' do
            assert_select 'td', '2'
            assert_select 'td', 'bar'
          end
          assert_select 'tr:not([class=alternate])' do
            assert_select 'td', '3'
            assert_select 'td', 'baz'
          end
        end
      end
    end

    def test_render_auto_body
      assert_equal view.render(:file => 'table_simple'), view.render(:file => 'table_auto_body')
    end

    def test_render_auto_columns
      html = view.render(:file => 'table_auto_columns')
      assert_html html, 'table[id=simple_table_records][class=simple_table_records list]' do
        assert_select 'thead tr' do
          assert_select 'th[scope=col]', 'Id'
          assert_select 'th[scope=col]', 'Title'
        end
        assert_select 'tbody' do
          assert_select 'tr' do
            assert_select 'td', '1'
            assert_select 'td', 'foo'
          end
          assert_select 'tr[class=alternate]' do
            assert_select 'td', '2'
            assert_select 'td', 'bar'
          end
        end
      end
    end

    def test_render_all
      html = view.render(:file => 'table_all')
      assert_html html, 'table[id=simple_table_records][class=simple_table_records list]' do
        assert_select 'thead tr' do
          assert_select 'th[colspan=3][class=total]', 'total: 3'
        end
        assert_select 'thead tr' do
          assert_select 'th[scope=col]', 'ID'
          assert_select 'th[scope=col]', 'Title'
          assert_select 'th[scope=col][class=action]', 'Action'
        end
        assert_select 'tbody' do
          assert_select 'tr' do
            assert_select 'td', '1'
            assert_select 'td', 'foo'
          end
          assert_select 'tr[class=alternate]' do
            assert_select 'td', '2'
            assert_select 'td', 'bar'
          end
        end
        assert_select 'tfoot tr td', 'foo'
      end
    end

    def test_render_all_with_empty
      view = ActionView::Base.new([File.dirname(__FILE__) + '/../fixtures/templates'], { :articles => [] })
      view.extend(SimpleTable)
      html = view.render(:file => 'table_all')
      assert_html html, 'p[class=empty]', 'no records!'
    end
  end
end
