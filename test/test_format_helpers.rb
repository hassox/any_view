require File.join(File.expand_path(File.dirname(__FILE__)), '/helper')

class TestFormatHelpers < Test::Unit::TestCase

  context 'for #simple_format method' do

    should "format simple text into html format" do
      actual_text = view_context.simple_format("Here is some basic text...\n...with a line break.")
      assert_equal "<p>Here is some basic text...\n<br />...with a line break.</p>", actual_text
    end

    should "format more text into html format" do
      actual_text = view_context.simple_format("We want to put a paragraph...\n\n...right there.")
      assert_equal "<p>We want to put a paragraph...</p>\n\n<p>...right there.</p>", actual_text
    end

    should "support defining a class for the paragraphs" do
      actual_text = view_context.simple_format("Look ma! A class!", :class => 'description')
      assert_equal "<p class=\"description\">Look ma! A class!</p>", actual_text
    end
  end

  context 'for #truncate method' do
    should "support default truncation" do
      actual_text = view_context.truncate("Once upon a time in a world far far away")
      assert_equal "Once upon a time in a world...", actual_text
    end

    should "support specifying length" do
      actual_text = view_context.truncate("Once upon a time in a world far far away", :length => 14)
      assert_equal "Once upon a...", actual_text
    end

    should "support specifying omission text" do
      actual_text = view_context.truncate("And they found that many people were sleeping better.", :length => 25, :omission => "(clipped)")
      assert_equal "And they found t(clipped)", actual_text
    end
  end

  context 'for #h and #h! method' do
    should "escape the simple html" do
      assert_equal '&lt;h1&gt;hello&lt;/h1&gt;', view_context.h('<h1>hello</h1>')
      assert_equal '&lt;h1&gt;hello&lt;/h1&gt;', view_context.escape_html('<h1>hello</h1>')
    end

    should "escape all brackets, quotes and ampersands" do
      assert_equal '&lt;h1&gt;&lt;&gt;&quot;&amp;demo&amp;&quot;&lt;&gt;&lt;/h1&gt;', view_context.h('<h1><>"&demo&"<></h1>')
    end

    should "return default text if text is empty" do
      assert_equal 'default', view_context.h!("", "default")
      assert_equal '&nbsp;', view_context.h!("")
    end

    should "return text escaped if not empty" do
      assert_equal '&lt;h1&gt;hello&lt;/h1&gt;', view_context.h!('<h1>hello</h1>')
    end
  end
end
