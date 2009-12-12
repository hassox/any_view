require 'dirge'
require ~'./any_view/core_ext/array'
require ~'./any_view/core_ext/hash'

module AnyView
  autoload :TiltBase,         ~'./any_view/tilt_base'

  module Helpers
    autoload :TagHelpers,      ~'./any_view/tag_helpers'
    autoload :AssetTagHelpers, ~'./any_view/asset_tag_helpers'
    autoload :FormatHelpers,   ~'./any_view/format_helpers'
    autoload :FormHelpers,     ~'./any_view/form_helpers'
  end

  module FormBuilder
    autoload :AbstractFormBuilder,  ~'./any_view/form_builder/abstract_form_builder'
    autoload :StandardFormBuilder,  ~'./any_view/form_builder/standard_form_builder'
  end

  def self.included(base)
    ah = AnyView::Helpers
    base.class_eval do
      include ah::TagHelpers, ah::AssetTagHelpers, ah::FormHelpers, ah::FormatHelpers
    end
  end
end


