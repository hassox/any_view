require File.join(File.expand_path(File.dirname(__FILE__)), '/helper')

class TestFormHelpers < Test::Unit::TestCase

  context 'for #form_tag method' do

    context "method faking" do
      should "display correct form with post as default" do
        actual_html = render("form_tag_methods.erb")
        # default
        assert_has_tag(:form, :class => "method-default", :method => 'post') { actual_html }
        assert_has_no_selector('form.method-default input', :type => 'hidden', :name => "_method") { actual_html }
      end
      should "display no hidden field for get method in erb" do
        actual_html = render("form_tag_methods.erb")
        # get
        assert_has_tag(:form, :class => "method-get", :method => 'get') { actual_html }
        assert_has_no_selector('form.method-get input', :type => 'hidden', :name => "_method") { actual_html }
      end
      should "display no hidden field for the post method in erb" do
        actual_html = render("form_tag_methods.erb")
        # post
        assert_has_tag(:form, :class => "method-post", :method => 'post') { actual_html }
        assert_has_no_selector('form.method-post input', :type => 'hidden', :name => "_method") { actual_html }
      end
      should "display a hidden field for the put method in erb" do
        actual_html = render("form_tag_methods.erb")
        # put
        assert_has_tag(:form, :class => "method-put", :method => 'post') { actual_html }
        assert_has_selector('form input', :type => 'hidden', :name => "_method", :value => 'put') { actual_html }
      end
      should "display a hidden field for the delete method in erb" do
        actual_html = render("form_tag_methods.erb")
        # delete
        assert_has_tag(:form, :class => "method-delete", :method => 'get') { actual_html }
        assert_has_selector('form input', :type => 'hidden', :name => "_method", :value => 'delete') { actual_html }
      end
      should "display correct form with post as default in haml" do
        actual_html = render("form_tag_methods.haml")
        # default
        assert_has_tag(:form, :class => "method-default", :method => 'post') { actual_html }
        assert_has_no_selector('form.method-default input', :type => 'hidden', :name => "_method") { actual_html }
      end
      should "display no hidden field for get method in haml" do
        actual_html = render("form_tag_methods.haml")
        # get
        assert_has_tag(:form, :class => "method-get", :method => 'get') { actual_html }
        assert_has_no_selector('form.method-get input', :type => 'hidden', :name => "_method") { actual_html }
      end
      should "display no hidden field for the post method in haml" do
        actual_html = render("form_tag_methods.haml")
        # post
        assert_has_tag(:form, :class => "method-post", :method => 'post') { actual_html }
        assert_has_no_selector('form.method-post input', :type => 'hidden', :name => "_method") { actual_html }
      end
      should "display a hidden field for the put method in haml" do
        actual_html = render("form_tag_methods.haml")
        # put
        assert_has_tag(:form, :class => "method-put", :method => 'post') { actual_html }
        assert_has_selector('form input', :type => 'hidden', :name => "_method", :value => 'put') { actual_html }
      end
      should "display a hidden field for the delete method in haml" do
        actual_html = render("form_tag_methods.haml")
        # delete
        assert_has_tag(:form, :class => "method-delete", :method => 'get') { actual_html }
        assert_has_selector('form input', :type => 'hidden', :name => "_method", :value => 'delete') { actual_html }
      end
    end

    should "display correct form with multipart encoding explicity" do
      actual_html = render("multipart.erb")
      assert_has_tag(:form, :class => "explicit", :enctype => "multipart/form-data") { actual_html }
    end

    should "display correct form with multipart encoding implicitly" do
      actual_html = render("multipart.erb")
      assert_has_tag(:form, :class => "implicit", :enctype => "multipart/form-data"){actual_html}
    end

    should "not display multipart encoding when there is no file tag" do
      actual_html = render("multipart.erb")
      assert_has_no_tag(:form, :class => "no_file", :enctype => "multipart/form-data"){actual_html}
    end

    should "display correct forms in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form', :action => '/simple'){result}
      assert_has_selector('form.advanced-form', :action => '/advanced', :id => 'advanced', :method => 'post'){result}
    end

    should "display correct forms in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form', :action => '/simple'){result}
      assert_has_selector('form.advanced-form', :action => '/advanced', :id => 'advanced', :method => 'get'){result}
    end
  end

  context 'for #field_set_tag method' do
    should "display correct field_sets in ruby" do
      actual_html = render('field_set_tag.erb')
      assert_has_tag(:fieldset, :class => 'basic') { actual_html }
      assert_has_tag('fieldset legend', :content => "Basic") { actual_html }
    end

    should "display correct field_sets in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form fieldset', :count => 1){ result }
      assert_has_no_selector('form.simple-form fieldset legend'){result}
      assert_has_selector('form.advanced-form fieldset', :count => 1, :class => 'advanced-field-set'){result}
      assert_has_selector('form.advanced-form fieldset legend', :content => "Advanced"){result}
    end

    should "display correct field_sets in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form fieldset', :count => 1){result}
      assert_has_no_selector('form.simple-form fieldset legend'){result}
      assert_has_selector('form.advanced-form fieldset', :count => 1, :class => 'advanced-field-set'){result}
      assert_has_selector('form.advanced-form fieldset legend', :content => "Advanced"){result}
    end
  end

  context 'for #error_messages_for method' do
    should "display correct error messages list in ruby" do
      user = stub(:class => "User", :errors => stub(:full_messages => ["1", "2"], :none? => false), :blank? => false)
      actual_html = view_context.error_messages_for(user)
      assert_has_tag('div.field-errors') { actual_html }
      assert_has_tag('div.field-errors p', :content => "The user could not be saved") { actual_html }
      assert_has_tag('div.field-errors ul.errors-list') { actual_html }
      assert_has_tag('div.field-errors ul.errors-list li', :count => 2) { actual_html }
    end

    should "display correct error messages list in erb" do
      result = render("form_tag.erb")
      assert_has_no_selector('form.simple-form .field-errors'){result}
      assert_has_selector('form.advanced-form .field-errors'){result}
      assert_has_selector('form.advanced-form .field-errors p', :content => "There are problems with saving user!"){result}
      assert_has_selector('form.advanced-form .field-errors ul.errors-list'){result}
      assert_has_selector('form.advanced-form .field-errors ul.errors-list li', :count => 3){result}
      assert_has_selector('form.advanced-form .field-errors ul.errors-list li', :content => "This is a second fake error"){result}
    end

    should "display correct error messages list in haml" do
      result = render("form_tag.haml")
      assert_has_no_selector('form.simple-form .field-errors'){result}
      assert_has_selector('form.advanced-form .field-errors'){result}
      assert_has_selector('form.advanced-form .field-errors p', :content => "There are problems with saving user!"){result}
      assert_has_selector('form.advanced-form .field-errors ul.errors-list'){result}
      assert_has_selector('form.advanced-form .field-errors ul.errors-list li', :count => 3){result}
      assert_has_selector('form.advanced-form .field-errors ul.errors-list li', :content => "This is a second fake error"){result}
    end
  end

  context 'for #label_tag method' do
    should "display label tag in ruby" do
      actual_html = view_context.label_tag(:username, :class => 'long-label', :caption => "Nickname")
      assert_has_tag(:label, :for => 'username', :class => 'long-label', :content => "Nickname: ") { actual_html }
    end

    should "display label tag in erb for simple form" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form label', :count => 4){result}
      assert_has_selector('form.simple-form label', :content => "Username", :for => 'username'){result}
      assert_has_selector('form.simple-form label', :content => "Password", :for => 'password'){result}
      assert_has_selector('form.simple-form label', :content => "Gender", :for => 'gender'){result}
    end

    should "display label tag in erb for advanced form" do
      result = render("form_tag.erb")
      assert_has_selector('form.advanced-form label', :count => 6){result}
      assert_has_selector('form.advanced-form label.first', :content => "Nickname", :for => 'username'){result}
      assert_has_selector('form.advanced-form label.first', :content => "Password", :for => 'password'){result}
      assert_has_selector('form.advanced-form label.about', :content => "About Me", :for => 'about'){result}
      assert_has_selector('form.advanced-form label.photo', :content => "Photo"   , :for => 'photo'){result}
      assert_has_selector('form.advanced-form label.gender', :content => "Gender"   , :for => 'gender'){result}
    end

    should "display label tag in haml for simple form" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form label', :count => 4){result}
      assert_has_selector('form.simple-form label', :content => "Username", :for => 'username'){result}
      assert_has_selector('form.simple-form label', :content => "Password", :for => 'password'){result}
      assert_has_selector('form.simple-form label', :content => "Gender", :for => 'gender'){result}
    end

    should "display label tag in haml for advanced form" do
      result = render("form_tag.haml")
      assert_has_selector('form.advanced-form label', :count => 6){result}
      assert_has_selector('form.advanced-form label.first', :content => "Nickname", :for => 'username'){result}
      assert_has_selector('form.advanced-form label.first', :content => "Password", :for => 'password'){result}
      assert_has_selector('form.advanced-form label.about', :content => "About Me", :for => 'about'){result}
      assert_has_selector('form.advanced-form label.photo', :content => "Photo"   , :for => 'photo'){result}
      assert_has_selector('form.advanced-form label.gender', :content => "Gender"   , :for => 'gender'){result}
    end
  end

  context 'for #hidden_field_tag method' do
    should "display hidden field in ruby" do
      actual_html = view_context.hidden_field_tag(:session_key, :id => 'session_id', :value => '56768')
      assert_has_tag(:input, :type => 'hidden', :id => "session_id", :name => 'session_key', :value => '56768') { actual_html }
    end

    should "display hidden field in erb" do
      result = render('form_tag.haml')
      assert_has_selector('form.simple-form input[type=hidden]', :count => 1, :name => 'session_id', :value => "__secret__"){result}
      assert_has_selector('form.advanced-form input[type=hidden]', :count => 1, :name => 'session_id', :value => "__secret__"){result}
    end

    should "display hidden field in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form input[type=hidden]', :count => 1, :name => 'session_id', :value => "__secret__"){result}
      assert_has_selector('form.advanced-form input[type=hidden]', :count => 1, :name => 'session_id', :value => "__secret__"){result}
    end
  end

  context 'for #text_field_tag method' do
    should "display text field in ruby" do
      actual_html = view_context.text_field_tag(:username, :class => 'long')
      assert_has_tag(:input, :type => 'text', :class => "long", :name => 'username') { actual_html }
    end

    should "display text field in erb" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form input[type=text]', :count => 1, :name => 'username'){result}
      assert_has_selector('form.advanced-form fieldset input[type=text]', :count => 1, :name => 'username', :id => 'the_username'){result}
    end

    should "display text field in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form input[type=text]', :count => 1, :name => 'username'){result}
      assert_has_selector('form.advanced-form fieldset input[type=text]', :count => 1, :name => 'username', :id => 'the_username'){result}
    end
  end

  context 'for #text_area_tag method' do
    should "display text area in ruby" do
      actual_html = view_context.text_area_tag(:about, :class => 'long')
      assert_has_tag(:textarea, :class => "long", :name => 'about') { actual_html }
    end

    should "display text area in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.advanced-form textarea', :count => 1, :name => 'about', :class => 'large'){result}
    end

    should "display text area in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.advanced-form textarea', :count => 1, :name => 'about', :class => 'large'){result}
    end
  end

  context 'for #password_field_tag method' do
    should "display password field in ruby" do
      actual_html = view_context.password_field_tag(:password, :class => 'long')
      assert_has_tag(:input, :type => 'password', :class => "long", :name => 'password') { actual_html }
    end

    should "display password field in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form input[type=password]', :count => 1, :name => 'password'){result}
      assert_has_selector('form.advanced-form input[type=password]', :count => 1, :name => 'password'){result}
    end

    should "display password field in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form input[type=password]', :count => 1, :name => 'password'){result}
      assert_has_selector('form.advanced-form input[type=password]', :count => 1, :name => 'password'){result}
    end
  end

  context 'for #file_field_tag method' do
    should "display file field in ruby" do
      actual_html = view_context.file_field_tag(:photo, :class => 'photo')
      assert_has_tag(:input, :type => 'file', :class => "photo", :name => 'photo') { actual_html }
    end

    should "display file field in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.advanced-form input[type=file]', :count => 1, :name => 'photo', :class => 'upload'){result}
    end

    should "display file field in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.advanced-form input[type=file]', :count => 1, :name => 'photo', :class => 'upload'){result}
    end
  end

  context "for #check_box_tag method" do
    should "display check_box tag in ruby" do
      actual_html = view_context.check_box_tag("clear_session")
      assert_has_tag(:input, :type => 'checkbox', :value => '1', :name => 'clear_session') { actual_html }
      assert_has_no_tag(:input, :type => 'hidden') { actual_html }
    end

    should "display check_box tag in ruby with extended attributes" do
      actual_html = view_context.check_box_tag("clear_session", :disabled => true, :checked => true)
      assert_has_tag(:input, :type => 'checkbox', :disabled => 'disabled', :checked => 'checked') { actual_html }
    end

    should "display check_box tag in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form input[type=checkbox]', :count => 1){result}
      assert_has_selector('form.advanced-form input[type=checkbox]', :value => "1", :checked => 'checked'){result}
    end

    should "display check_box tag in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form input[type=checkbox]', :count => 1){result}
      assert_has_selector('form.advanced-form input[type=checkbox]', :value => "1", :checked => 'checked'){result}
    end
  end

  context "for #radio_button_tag method" do
    should "display radio_button tag in ruby" do
      actual_html = view_context.radio_button_tag("gender", :value => 'male')
      assert_has_tag(:input, :type => 'radio', :value => 'male', :name => 'gender') { actual_html }
    end

    should "display radio_button tag in ruby with extended attributes" do
      actual_html = view_context.radio_button_tag("gender", :disabled => true, :checked => true)
      assert_has_tag(:input, :type => 'radio', :disabled => 'disabled', :checked => 'checked') { actual_html }
    end

    should "display radio_button tag in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form input[type=radio]', :count => 1, :value => 'male'){result}
      assert_has_selector('form.simple-form input[type=radio]', :count => 1, :value => 'female'){result}
      assert_has_selector('form.advanced-form input[type=radio]', :value => "male", :checked => 'checked'){result}
      assert_has_selector('form.advanced-form input[type=radio]', :value => "female"){result}
    end

    should "display radio_button tag in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form input[type=radio]', :count => 1, :value => 'male'){result}
      assert_has_selector('form.simple-form input[type=radio]', :count => 1, :value => 'female'){result}
      assert_has_selector('form.advanced-form input[type=radio]', :value => "male", :checked => 'checked'){result}
      assert_has_selector('form.advanced-form input[type=radio]', :value => "female"){result}
    end
  end

  context "for #select_tag method" do
    should "display select tag in ruby" do
      actual_html = view_context.select_tag(:favorite_color, :options => ['green', 'blue', 'black'], :include_blank => true)
      assert_has_tag(:select, :name => 'favorite_color') { actual_html }
      assert_has_tag('select option:first-child', :content => '') { actual_html }
      assert_has_tag('select option', :content => 'green', :value => 'green') { actual_html }
      assert_has_tag('select option', :content => 'blue', :value => 'blue') { actual_html }
      assert_has_tag('select option', :content => 'black', :value => 'black') { actual_html }
    end

    should "display select tag in ruby with extended attributes" do
      actual_html = view_context.select_tag(:favorite_color, :disabled => true, :options => ['only', 'option'])
      assert_has_tag(:select, :disabled => 'disabled') { actual_html }
    end

    should "display select tag in ruby with multiple attribute" do
      actual_html = view_context.select_tag(:favorite_color, :multiple => true, :options => ['only', 'option'])
      assert_has_tag(:select, :multiple => 'multiple', :name => 'favorite_color[]') { actual_html }
    end

    should "display options with values and selected" do
      options = [['Green', 'green1'], ['Blue', 'blue1'], ['Black', "black1"]]
      actual_html = view_context.select_tag(:favorite_color, :options => options, :selected => 'green1')
      assert_has_tag(:select, :name => 'favorite_color') { actual_html }
      assert_has_tag('select option', :selected => 'selected', :count => 1) { actual_html }
      assert_has_tag('select option', :content => 'Green', :value => 'green1', :selected => 'selected') { actual_html }
      assert_has_tag('select option', :content => 'Blue', :value => 'blue1') { actual_html }
      assert_has_tag('select option', :content => 'Black', :value => 'black1') { actual_html }
    end

    should "display select tag in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form select', :count => 1, :name => 'color'){result}
      assert_has_selector('select option', :content => 'green',  :value => 'green'){result}
      assert_has_selector('select option', :content => 'orange', :value => 'orange'){result}
      assert_has_selector('select option', :content => 'purple', :value => 'purple'){result}
      assert_has_selector('form.advanced-form select', :name => 'fav_color'){result}
      assert_has_selector('select option', :content => 'green',  :value => '1'){result}
      assert_has_selector('select option', :content => 'orange', :value => '2', :selected => 'selected'){result}
      assert_has_selector('select option', :content => 'purple', :value => '3'){result}
    end

    should "display select tag in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form select', :count => 1, :name => 'color'){result}
      assert_has_selector('select option', :content => 'green',  :value => 'green'){result}
      assert_has_selector('select option', :content => 'orange', :value => 'orange'){result}
      assert_has_selector('select option', :content => 'purple', :value => 'purple'){result}
      assert_has_selector('form.advanced-form select', :name => 'fav_color'){result}
      assert_has_selector('select option', :content => 'green',  :value => '1'){result}
      assert_has_selector('select option', :content => 'orange', :value => '2', :selected => 'selected'){result}
      assert_has_selector('select option', :content => 'purple', :value => '3'){result}
    end

    should "handle empty collections" do
      actual_html = view_context.select_tag(:empty, :collection => [], :fields => [:foo, :bar])
      assert_has_tag(:select, :name => 'empty') { actual_html }
    end
  end

  context 'for #submit_tag method' do
    should "display submit tag in ruby" do
      actual_html = view_context.submit_tag("Update", :class => 'success')
      assert_has_tag(:input, :type => 'submit', :class => "success", :value => 'Update') { actual_html }
    end

    should "display submit tag in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.simple-form input[type=submit]', :count => 1, :value => "Submit"){result}
      assert_has_selector('form.advanced-form input[type=submit]', :count => 1, :value => "Login"){result}
    end

    should "display submit tag in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.simple-form input[type=submit]', :count => 1, :value => "Submit"){result}
      assert_has_selector('form.advanced-form input[type=submit]', :count => 1, :value => "Login"){result}
    end
  end

  context 'for #button_tag method' do
    should "display submit tag in ruby" do
      actual_html = view_context.button_tag("Cancel", :class => 'clear')
      assert_has_tag(:input, :type => 'button', :class => "clear", :value => 'Cancel') { actual_html }
    end

    should "display submit tag in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.advanced-form input[type=button]', :count => 1, :value => "Cancel"){result}
    end

    should "display submit tag in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.advanced-form input[type=button]', :count => 1, :value => "Cancel"){result}
    end
  end

  context 'for #image_submit_tag method' do
    should "display image submit tag in ruby with relative path" do
      actual_html = view_context.image_submit_tag('buttons/ok.png', :class => 'success')
      assert_has_tag(:input, :type => 'image', :class => "success", :src => '/images/buttons/ok.png') { actual_html }
    end

    should "display image submit tag in ruby with absolute path" do
      actual_html = view_context.image_submit_tag('/system/ok.png', :class => 'success')
      assert_has_tag(:input, :type => 'image', :class => "success", :src => '/system/ok.png') { actual_html }
    end

    should "display image submit tag in erb" do
      result = render("form_tag.erb")
      assert_has_selector('form.advanced-form input[type=image]', :count => 1, :src => "/images/buttons/submit.png"){result}
    end

    should "display image submit tag in haml" do
      result = render("form_tag.haml")
      assert_has_selector('form.advanced-form input[type=image]', :count => 1, :src => "/images/buttons/submit.png"){result}
    end
  end

end
