require File.join(File.expand_path(File.dirname(__FILE__)), '/helper')

class TestTagHelpers < Test::Unit::TestCase
  context 'for #tag method' do
    should("support tags with no content no attributes") do
      assert_has_tag(:br) { view_context.tag(:br) }
    end
    should("support tags with no content with attributes") do
      actual_html = view_context.tag(:br, :style => 'clear:both', :class => 'yellow')
      assert_has_tag(:br, :class => 'yellow', :style=>'clear:both') { actual_html }
    end
    should "support selected attribute by using 'selected' if true" do
      actual_html = view_context.tag(:option, :selected => true)
      assert_has_tag('option', :selected => 'selected') { actual_html }
    end
    should "support tags with content no attributes" do
      assert_has_tag(:p, :content => "Demo String") { view_context.tag(:p, :content => "Demo String") }
    end
    should "support tags with content and attributes" do
      actual_html = view_context.tag(:p, :content => "Demo", :class => 'large', :id => 'intro')
      assert_has_tag('p#intro.large', :content => "Demo") { actual_html }
    end
    should "support open tags" do
      actual_html = view_context.tag(:p, :class => 'demo', :open => true)
      assert_equal "<p class=\"demo\">", actual_html
    end
  end

  context 'for #content_tag method' do
    should "support tags with erb" do
      result = render("content_tag.erb")
      assert_has_selector(:p, :content => "Test 1", :class => 'test', :id => 'test1'){result}
      assert_has_selector(:p, :content => "Test 2"){result}
      assert_has_selector(:p, :content => "Test 3"){result}
      assert_has_selector(:p, :content => "Test 4"){result}
    end

    should "support tags with haml" do
      result = render('content_tag.haml')
      assert_has_selector(:p, :content => "Test 1", :class => 'test', :id => 'test1'){result}
      assert_has_selector(:p, :content => "Test 2"){result}
      assert_has_selector(:p, :content => "Test 3", :class => 'test', :id => 'test3'){result}
      assert_has_selector(:p, :content => "Test 4"){result}
    end
  end

  context 'for #input_tag method' do
    should "support field with type" do
      assert_has_tag('input[type=text]') { view_context.input_tag(:text) }
    end
    should "support field with type and options" do
      actual_html = view_context.input_tag(:text, :class => "first", :id => 'texter')
      assert_has_tag('input.first#texter[type=text]') { actual_html }
    end
    should "support checked attribute by using 'checked' if true" do
      actual_html = view_context.input_tag(:checkbox, :checked => true)
      assert_has_tag('input[type=checkbox]', :checked => 'checked') { actual_html }
    end
    should "support disabled attribute by using 'disabled' if true" do
      actual_html = view_context.input_tag(:checkbox, :disabled => true)
      assert_has_tag('input[type=checkbox]', :disabled => 'disabled') { actual_html }
    end
  end

end
