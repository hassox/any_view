module AnyView
  module Helpers
    module FormatHelpers

      # Returns escaped text to protect against malicious content
      def escape_html(text)
        Rack::Utils.escape_html(text)
      end
      alias h escape_html
      alias sanitize_html escape_html

      # Returns escaped text to protect against malicious content
      # Returns blank if the text is empty
      def h!(text, blank_text = '&nbsp;')
        return blank_text if text.nil? || text.empty?
        h text
      end

      # Truncates a given text after a given :length if text is longer than :length (defaults to 30).
      # The last characters will be replaced with the :omission (defaults to "…") for a total length not exceeding :length.
      # truncate("Once upon a time in a world far far away", :length => 8) => "Once upon..."
      def truncate(text, *args)
        options = args.extract_options!
        options = options.dup
        options.reverse_merge!(:length => 30, :omission => "...")
        if text
          len = options[:length] - options[:omission].length
          chars = text
          (chars.length > options[:length] ? chars[0...len] + options[:omission] : text).to_s
        end
      end


      # Returns text transformed into HTML using simple formatting rules. Two or more consecutive newlines(\n\n) are considered
      # as a paragraph and wrapped in <p> tags. One newline (\n) is considered as a linebreak and a <br /> tag is appended.
      # This method does not remove the newlines from the text.
      # simple_format("hello\nworld") # => "<p>hello<br/>world</p>"
      def simple_format(text, html_options={})
        start_tag = tag('p', html_options.merge(:open => true))
        text = text.to_s.dup
        text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
        text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
        text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
        text.insert 0, start_tag
        text << "</p>"
      end
    end
  end
end
