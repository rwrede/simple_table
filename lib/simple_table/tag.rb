require 'active_support/core_ext/class/inheritable_attributes'

module SimpleTable
  class Tag
    include ActionView::Helpers::TagHelper

    class_inheritable_accessor :level, :tag_name

    attr_reader :options, :parent

    def initialize(parent = nil, options = {})
      @parent = parent
      @options = options
      yield self if block_given?
    end

    def collection_class
      table.collection_class
    end

    def collection_name
      table.collection_name
    end

    def table
      is_a?(Table) ? self : parent.try(:table)
    end

    def head?
      is_a?(Head) || !!parent.try(:head?)
    end

    def render(content = nil, escape = false)
      content = content.join(' ') if content.respond_to?(:join)
      yield(content = '') if content.nil? && block_given?
      content = lf(indent(content.to_s))
      lf(content_tag(tag_name, content, options, escape))
    end

    def add_class(klass)
      add_class!(options, klass)
    end

    protected
      def lf(str)
        "\n#{str}\n"
      end

      def indent(str)
        str.gsub(/^/, "  ")
      end

      def add_class!(options, klass)
        unless klass.blank?
          options[:class] ||= ''
          options[:class] = options[:class].to_s.split(' ').push(klass).join(' ')
        end
      end

      def add_header!(options, headers)
        unless headers.blank?
          options[:headers] ||= ''
          options[:headers] = options[:headers].to_s.split(' ').push(headers).join(' ')
        end
      end
  end
end
