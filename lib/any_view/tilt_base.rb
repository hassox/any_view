require 'tilt'

class Tilt::Template
  def render_with_any_view(scope=Object.new, locals = {}, &blk)
    scope.template_type = self.class if scope.respond_to?(:template_type=)
    render_without_any_view(scope, locals, &blk)
  end
  alias_method :render_without_any_view, :render
  alias_method :render, :render_with_any_view
end

[::Tilt::ERBTemplate, ::Tilt::ErubisTemplate].each do |klass|
  unless klass.default_output_variable && klass.default_output_variable =~ /\@/
    klass.default_output_variable = "@_outbuf"
  end
end

module AnyView
  # Provides capture and concat methods for use inside templates with the Tilt gem.
  module TiltBase
    class Error < StandardError; end
    class CaptureMethodNotFound < Error; end
    class ContentMethodNotFound < Error; end

    def self.included(base)
      base.class_eval do
        attr_writer :template_type unless self.method_defined?(:template_type=)
        attr_reader :template_type unless self.method_defined?(:template_type)
      end
    end

    class << self
      # Keeps track of the concatenation methods for each template type.
      # If you have your own template types, then you should add them here
      def concat_methods
        @concat_methods ||= {}
      end

      def capture_methods
        @capture_methods ||= {}
      end

      def capture_method_for(template)
        capture_methods[template]
      end

      def concat_method_for(template)
        concat_methods[template]
      end
    end

    capture_methods[::Tilt::HamlTemplate  ] = :_haml_capture
    capture_methods[::Tilt::ERBTemplate   ] = :_erb_capture
    capture_methods[::Tilt::ErubisTemplate] = :_erubis_capture

    concat_methods[ ::Tilt::HamlTemplate  ] = :_haml_concat
    concat_methods[ ::Tilt::ERBTemplate   ] = :_erb_concat
    concat_methods[ ::Tilt::ErubisTemplate] = :_erbis_concat

    def capture_content(*args, &blk)
      opts = args.extract_options!
      capture_method = AnyView::TiltBase.capture_method_for(template_type)

      raise CaptureMethodNotFound, "Capture Method not found for Template Type: #{opts[:template_type].inspect}" unless capture_method
      send(capture_method, *args, &blk)
    end

    def concat_content(string, opts = {})
      concat_method = AnyView::TiltBase.concat_method_for(template_type)

      raise ConcatMethodNotFound, "Concat Method not found for Template Type: #{opts[:template_type].inspect}" unless concat_method
      send(concat_method, string)
    end

    def _haml_capture(*args, &block)
      with_haml_buffer(Haml::Buffer.new(nil, :encoding => "UTF-8")) do
        capture_haml(*args, &block)
      end
    end

    def _erb_capture(*args, &block)
      _saved_buffer = _erb_buffer
      _set_erb_buffer ''

      block.call(*args)

      ret = _erb_buffer
      _set_erb_buffer _saved_buffer
      ret
    end

    def _erubis_capture(*args, &block)
      _saved_buffer       = _erubis_buffer
      _set_erubis_buffer  = ''

      block.call(*args)

      ret = _erb_buffer
      _set_erubis_buffer _saved_buffer
    end

    def _haml_concat(string)
      haml_concat(string)
    end

    def _erb_concat(string)
      _erb_buffer << string
    end

    def _erubis_concat(string)
      _erubis_buffer << string
    end

    private
    def _set_erb_buffer(new_buffer)
      outvar = ::Tilt::ERBTemplate.default_output_variable
      instance_variable_set(outvar, new_buffer)
    end

    def _erb_buffer
      outvar = Tilt::ERBTemplate.default_output_variable
      instance_variable_get(outvar)
    end

    def _set_erubis_buffer(new_buffer)
      outvar = Tilt::ErubisTemplate.default_output_variable
      instance_variable_set(outvar, new_buffer)
    end

    def _erubis_buffer
      outvar = ::Tile::ErubisTemplate.default_output_variable
      instance_variable_get(outvar)
    end
  end
end

