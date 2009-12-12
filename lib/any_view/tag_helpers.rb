module AnyView
  module Helpers
    module TagHelpers
      # Creates an html input field with given type and options
      # input_tag :text, :class => "test"
      def input_tag(type, options = {})
        options = options.dup
        options[:type] = type
        tag(:input, options)
      end

      # Creates an html tag with given name, content and options
      # @example
      #   content_tag(:p, "hello", :class => 'light')
      #   content_tag(:p, :class => 'dark') do ... end
      # parameters: content_tag(name, content=nil, options={}, &block)
      # Writes directly to the buffer
      def content_tag(*args, &block)
        name = args.first
        options = args.extract_options!
        tag_html = block_given? ? capture_content(options, &block) : args[1]
        tag_result = tag(name, options.merge(:content => tag_html))
        concat_content(tag_result)
      end

      # Creates an html tag with the given name and options
      # @example
      #   tag(:br, :style => 'clear:both')
      #   tag(:p, :content => "hello", :class => 'large')
      # @return a string
      def tag(name, options={})
        content, open_tag = options.delete(:content), options.delete(:open)
        identity_tag_attributes.each { |attr| options[attr] = attr.to_s if options[attr]  }
        html_attrs = options.collect { |a, v| v.blank? ? nil : "#{a}=\"#{v}\"" }.compact.join(" ")
        base_tag = (html_attrs.present? ? "<#{name} #{html_attrs}" : "<#{name}")
        base_tag << (open_tag ? ">" : (content ? ">#{content}</#{name}>" : " />"))
      end

      protected

      # Returns a list of attributes which can only contain an identity value (i.e selected)
      def identity_tag_attributes
        [:checked, :disabled, :selected, :multiple]
      end
    end
  end
end
