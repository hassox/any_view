require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'webrat'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require File.dirname(__FILE__) + '/../lib/any_view'

class Renderer
  class ViewContext
    include AnyView::TiltBase
    include AnyView
  end

  def self.path
    @path ||= File.join(File.expand_path(File.dirname(__FILE__)), './fixtures')
  end

  def self.template(name)
    Tilt.new(File.join(path, name))
  end

  def template(name)
    self.class.template(name)
  end

  def render(name, locals = {})
    template(name).render(ViewContext.new, locals)
  end
end

class Test::Unit::TestCase

  def view_context
    Renderer::ViewContext.new
  end

  def render(*args)
    Renderer.new.render(*args)
  end

  def stop_time_for_test
    time = Time.now
    Time.stubs(:now).returns(time)
    return time
  end

  # assert_has_tag(:h1, :content => "yellow") { "<h1>yellow</h1>" }
  # In this case, block is the html to evaluate
  def assert_has_tag(name, attributes = {}, &block)
    html = block && block.call
    matcher = Webrat::Matchers::HaveSelector.new(name, attributes)
    raise "Please specify a block!" if html.blank?
    assert matcher.matches?(html), matcher.failure_message
  end

  # assert_has_no_tag, tag(:h1, :content => "yellow") { "<h1>green</h1>" }
  # In this case, block is the html to evaluate
  def assert_has_no_tag(name, attributes = {}, &block)
    html = block && block.call
    attributes.merge!(:count => 0)
    matcher = Webrat::Matchers::HaveSelector.new(name, attributes)
    raise "Please specify a block!" if html.blank?
    assert matcher.matches?(html), matcher.failure_message
  end

  def assert_has_selector(name, attributes = {}, &block)
    html = block && block.call
    matcher = Webrat::Matchers::HaveSelector.new(name, attributes)
    raise "Please specify a block!" if html.blank?
    assert matcher.matches?(html), matcher.failure_message
  end

  def assert_has_no_selector(name, attributes = {}, &block)
    html = block && block.call
    matcher = Webrat::Matchers::HaveSelector.new(name, attributes)
    raise "Please specify a block!" if html.blank?
    assert !matcher.matches?(html), matcher.negative_failure_message
  end

  # Silences the output by redirecting to stringIO
  # silence_logger { ...commands... } => "...output..."
  def silence_logger(&block)
    orig_stdout = $stdout
    $stdout = log_buffer = StringIO.new
    block.call
    $stdout = orig_stdout
    log_buffer.rewind && log_buffer.read
  end

  # Asserts that a file matches the pattern
  def assert_match_in_file(pattern, file)
    assert File.exist?(file), "File '#{file}' does not exist!"
    assert_match pattern, File.read(file)
  end
end

class MarkupUser
  def errors; Errors.new; end
  def session_id; 45; end
  def gender; 'male'; end
  def remember_me; '1'; end
  def image; end
  def permission; Permission.new; end
end

class Permission
  def can_edit; true; end
  def can_delete; false; end
end

class Errors < Array
  def initialize; self << [:fake, :second, :third]; end
  def full_messages
    ["This is a fake error", "This is a second fake error", "This is a third fake error"]
  end
end


