module AnyView
  module Helpers
    module FormBuilder
      class AbstractFormBuilder
        attr_accessor :view_context, :object

        def initialize(view_context, object)
          @view_context = view_context
          @object   = object
          raise "FormBuilder view_context must be initialized!" unless view_context
          raise "FormBuilder object must be not be nil value. If there's no object, use a symbol instead! (i.e :user)" unless object
        end

        # f.error_messages
        def error_messages(options={})
          @view_context.error_messages_for(@object, options)
        end

        # f.label :username, :caption => "Nickname"
        def label(field, options={})
          options.reverse_merge!(:caption => field.to_s.titleize)
          @view_context.label_tag(field_id(field), options)
        end

        # f.hidden_field :session_id, :value => "45"
        def hidden_field(field, options={})
          options.reverse_merge!(:value => field_value(field), :id => field_id(field))
          @view_context.hidden_field_tag field_name(field), options
        end

        # f.text_field :username, :value => "(blank)", :id => 'username'
        def text_field(field, options={})
          options.reverse_merge!(:value => field_value(field), :id => field_id(field))
          @view_context.text_field_tag field_name(field), options
        end

        # f.text_area :summary, :value => "(enter summary)", :id => 'summary'
        def text_area(field, options={})
          options.reverse_merge!(:value => field_value(field), :id => field_id(field))
          @view_context.text_area_tag field_name(field), options
        end

        # f.password_field :password, :id => 'password'
        def password_field(field, options={})
          options.reverse_merge!(:value => field_value(field), :id => field_id(field))
          @view_context.password_field_tag field_name(field), options
        end

        # f.select :color, :options => ['red', 'green'], :include_blank => true
        # f.select :color, :collection => @colors, :fields => [:name, :id]
        def select(field, options={})
          options.reverse_merge!(:id => field_id(field), :selected => field_value(field))
          @view_context.select_tag field_name(field), options
        end

        # f.check_box :remember_me, :value => 'true', :uncheck_value => '0'
        def check_box(field, options={})
          unchecked_value = options.delete(:uncheck_value) || '0'
          options.reverse_merge!(:id => field_id(field), :value => '1')
          options.merge!(:checked => true) if values_matches_field?(field, options[:value])
          html = @view_context.check_box_tag field_name(field), options
          html << hidden_field(field, :value => unchecked_value, :id => nil)
        end

        # f.radio_button :gender, :value => 'male'
        def radio_button(field, options={})
          options.reverse_merge!(:id => field_id(field, options[:value]))
          options.merge!(:checked => true) if values_matches_field?(field, options[:value])
          @view_context.radio_button_tag field_name(field), options
        end

        # f.file_field :photo, :class => 'avatar'
        def file_field(field, options={})
          options.reverse_merge!(:id => field_id(field))
          @view_context.file_field_tag field_name(field), options
        end

        # f.submit "Update", :class => 'large'
        def submit(caption="Submit", options={})
          @view_context.submit_tag caption, options
        end

        # f.simage_submitubmit "buttons/submit.png", :class => 'large'
        def image_submit(source, options={})
          @view_context.image_submit_tag source, options
        end

        protected

        # Returns the known field types for a formbuilder
        def self.field_types
          [:hidden_field, :text_field, :text_area, :password_field, :file_field, :radio_button, :check_box, :select]
        end

        # Returns the object's models name
        #   => user_assignment
        def object_name
          object.is_a?(Symbol) ? object : object.class.to_s.underscore.gsub("/","_")
        end

        # Returns true if the value matches the value in the field
        # field_has_value?(:gender, 'male')
        def values_matches_field?(field, value)
          value.present? && (field_value(field).to_s == value.to_s || field_value(field).to_s == 'true')
        end

        # Returns the value for the object's field
        # field_value(:username) => "Joey"
        def field_value(field)
          @object && @object.respond_to?(field) ? @object.send(field) : ""
        end

        # Returns the name for the given field
        # field_name(:username) => "user[username]"
        def field_name(field)
          "#{object_name}[#{field}]"
        end

        # Returns the id for the given field
        # field_id(:username) => "user_username"
        # field_id(:gender, :male) => "user_gender_male"
        def field_id(field, value=nil)
          value.blank? ? "#{object_name}_#{field}" : "#{object_name}_#{field}_#{value}"
        end
      end
    end
  end
end
