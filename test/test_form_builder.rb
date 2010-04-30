require File.join(File.expand_path(File.dirname(__FILE__)), '/helper')

class TestFormBuilder < Test::Unit::TestCase
  def setup
    error_stub = stub(:full_messages => ["1", "2"], :none? => false)
    role_types = [stub(:name => 'Admin', :id => 1), stub(:name => 'Moderate', :id => 2),  stub(:name => 'Limited', :id => 3)]
    @user = stub(:errors => error_stub, :class => 'User', :first_name => "Joe", :session_id => 54)
    @user.stubs(:role_types => role_types, :role => "1")
    @user_none = stub(:errors => stub(:none? => true), :class => 'User')

    Renderer::ViewContext.class_eval do
      unless method_defined?(:standard_builder)
        def standard_builder(object = nil)
          AnyView::Helpers::FormBuilder::StandardFormBuilder.new(self, object)
        end
      end
    end
  end

  def teardown
    Renderer::ViewContext.class_eval do
      undef :standard_builder
    end
  end

  def standard_builder(object=@user)
    view_context.standard_builder(object)
  end

  context 'for #form_for method' do
    should "display correct form html" do
      result = render("basic_form_for.erb")
      assert_has_tag('form', :action => '/register', :id => 'register', :method => 'post', :content => "Demo") { result }
      assert_has_tag('form input[type=hidden]', :name => '_method', :count => 0) { result } # no method action field
    end

    should "display correct form html with method :put" do
      actual_html = render("put_form_for.erb")
      assert_has_tag('form', :action => '/update', :method => 'post') { actual_html }
      assert_has_tag('form input', :type => 'hidden', :name => "_method", :value => 'put') { actual_html }
    end

    should "display correct form html with method :delete" do
      actual_html = render("delete_form_for.erb")
      assert_has_tag('form', :action => '/destroy', :method => 'get') { actual_html }
      assert_has_tag('form input', :type => 'hidden', :name => "_method", :value => 'delete') { actual_html }
    end

    should "display correct form html with multipart" do
      actual_html = render("multipart_form_for.erb")
      assert_has_tag('form', :action => '/register', :enctype => "multipart/form-data") { actual_html }
    end

    should "support changing form builder type" do

      form_html = lambda { render("builder_type_form_for.erb") }
      assert_raise(NoMethodError) { form_html.call }
    end

    should "support using default standard builder" do
      actual_html = render("standard_form_builder.erb")
      assert_has_tag('form p input[type=text]') { actual_html }
    end

    should "display fail for form with nil object" do
      assert_raises(RuntimeError) { render("form_for_nil.erb") }
    end

    should "display correct form in haml" do
      result = render("form_for.haml")
      assert_has_selector(:form, :action => '/demo', :id => 'demo'){result}
      assert_has_selector(:form, :action => '/another_demo', :id => 'demo2', :method => 'get'){result}
      assert_has_selector(:form, :action => '/third_demo', :id => 'demo3', :method => 'get'){result}
    end

    should "display correct form in erb" do
      result = render("form_for.erb")
      assert_has_selector(:form, :action => '/demo', :id => 'demo'){result}
      assert_has_selector(:form, :action => '/another_demo', :id => 'demo2', :method => 'get'){result}
      assert_has_selector(:form, :action => '/third_demo', :id => 'demo3', :method => 'get'){result}
    end
  end

  context 'for #fields_for method' do
    should 'display correct fields html' do
      actual_html = render("fields_for_basic.erb")
      assert_has_tag(:input, :type => 'text', :name => 'markup_user[first_name]', :id => 'markup_user_first_name') { actual_html }
    end

    should "display fail for nil object" do
      assert_raises(RuntimeError) { render('fields_for_nil.erb')}
    end

    should 'display correct simple fields in haml' do
      result = render("fields_for.haml")
      assert_has_selector(:form, :action => '/demo1', :id => 'demo-fields-for'){result}
      assert_has_selector('#demo-fields-for input', :type => 'text', :name => 'markup_user[gender]', :value => 'male'){result}
      assert_has_selector('#demo-fields-for input', :type => 'checkbox', :name => 'permission[can_edit]', :value => '1', :checked => 'checked'){result}
      assert_has_selector('#demo-fields-for input', :type => 'checkbox', :name => 'permission[can_delete]'){result}
    end

    should "display correct simple fields in erb" do
      result = render("fields_for.erb")
      assert_has_selector(:form, :action => '/demo1', :id => 'demo-fields-for'){result}
      assert_has_selector('#demo-fields-for input', :type => 'text', :name => 'markup_user[gender]', :value => 'male'){result}
      assert_has_selector('#demo-fields-for input', :type => 'checkbox', :name => 'permission[can_edit]', :value => '1', :checked => 'checked'){result}
      assert_has_selector('#demo-fields-for input', :type => 'checkbox', :name => 'permission[can_delete]'){result}
    end
  end

  # ===========================
  # AbstractFormBuilder
  # ===========================

  context 'for #error_messages method' do
    should "display correct form html with no record" do
      actual_html = standard_builder(@user_none).error_messages(:header_message => "Demo form cannot be saved")
      assert actual_html.blank?
    end

    should "display correct form html with valid record" do
      actual_html = standard_builder(@user).error_messages(:header_message => "Demo form cannot be saved")
      assert_has_tag('div.field-errors p', :content => "Demo form cannot be saved") { actual_html }
      assert_has_tag('div.field-errors ul.errors-list li', :content => "1") { actual_html }
      assert_has_tag('div.field-errors ul.errors-list li', :content => "2") { actual_html }
    end

    should "display correct form in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo div.field-errors p', :content => "custom MarkupUser cannot be saved!"){result}
      assert_has_selector('#demo div.field-errors ul.errors-list li', :content => "This is a fake error"){result}
      assert_has_selector('#demo2 div.field-errors p', :content => "custom MarkupUser cannot be saved!"){result}
      assert_has_selector('#demo2 div.field-errors ul.errors-list li', :content => "This is a fake error"){result}
    end

    should "display correct form in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo div.field-errors p', :content => "custom MarkupUser cannot be saved!"){result}
      assert_has_selector('#demo div.field-errors ul.errors-list li', :content => "This is a fake error"){result}
      assert_has_selector('#demo2 div.field-errors p', :content => "custom MarkupUser cannot be saved!"){result}
      assert_has_selector('#demo2 div.field-errors ul.errors-list li', :content => "This is a fake error"){result}
    end
  end

  context 'for #label method' do
    should "display correct label html" do
      actual_html = standard_builder(@user).label(:first_name, :class => 'large', :caption => "F. Name")
      assert_has_tag('label', :class => 'large', :for => 'user_first_name', :content => "F. Name: ") { actual_html }
    end

    should "display correct label in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo label', :content => "Login: ", :class => 'user-label'){result}
      assert_has_selector('#demo label', :content => "About Me: "){result}
      assert_has_selector('#demo2 label', :content => "Nickname: ", :class => 'label'){result}
    end

    should "display correct label in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo label', :content => "Login: ", :class => 'user-label'){result}
      assert_has_selector('#demo label', :content => "About Me: "){result}
      assert_has_selector('#demo2 label', :content => "Nickname: ", :class => 'label'){result}
    end
  end

  context 'for #hidden_field method' do
    should "display correct hidden field html" do
      actual_html = standard_builder(@user).hidden_field(:session_id, :class => 'hidden')
      assert_has_tag('input.hidden[type=hidden]', :value => "54", :id => 'user_session_id', :name => 'user[session_id]') { actual_html }
    end

    should "display correct hidden field in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo input[type=hidden]', :id => 'markup_user_session_id', :value => "45"){result}
      assert_has_selector('#demo2 input', :type => 'hidden', :name => 'markup_user[session_id]'){result}
    end

    should "display correct hidden field in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo input[type=hidden]', :id => 'markup_user_session_id', :value => "45"){result}
      assert_has_selector('#demo2 input', :type => 'hidden', :name => 'markup_user[session_id]'){result}
    end
  end

  context 'for #text_field method' do
    should "display correct text field html" do
      actual_html = standard_builder(@user).text_field(:first_name, :class => 'large')
      assert_has_tag('input.large[type=text]', :value => "Joe", :id => 'user_first_name', :name => 'user[first_name]') { actual_html }
    end

    should "display correct text field in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo input.user-text[type=text]', :id => 'markup_user_username', :value => "John"){result}
      assert_has_selector('#demo2 input', :type => 'text', :class => 'input', :name => 'markup_user[username]'){result}
    end

    should "display correct text field in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo input.user-text[type=text]', :id => 'markup_user_username', :value => "John"){result}
      assert_has_selector('#demo2 input', :type => 'text', :class => 'input', :name => 'markup_user[username]'){result}
    end
  end

  context 'for #check_box method' do
    should "display correct checkbox html" do
      actual_html = standard_builder(@user).check_box(:confirm_destroy, :class => 'large')
      assert_has_tag('input.large[type=checkbox]', :id => 'user_confirm_destroy', :name => 'user[confirm_destroy]') { actual_html }
      assert_has_tag('input[type=hidden]', :name => 'user[confirm_destroy]', :value => '0') { actual_html }
    end

    should "display correct checkbox html when checked" do
      actual_html = standard_builder(@user).check_box(:confirm_destroy, :checked => true)
      assert_has_tag('input[type=checkbox]', :checked => 'checked', :name => 'user[confirm_destroy]') { actual_html }
    end

    should "display correct checkbox html as checked when object value matches" do
      @user.stubs(:show_favorites => 'human')
      actual_html = standard_builder(@user).check_box(:show_favorites, :value => 'human')
      assert_has_tag('input[type=checkbox]', :checked => 'checked', :name => 'user[show_favorites]') { actual_html }
    end

    should "display correct checkbox html as checked when object value is true" do
      @user.stubs(:show_favorites => true)
      actual_html = standard_builder(@user).check_box(:show_favorites, :value => '1')
      assert_has_tag('input[type=checkbox]', :checked => 'checked', :name => 'user[show_favorites]') { actual_html }
    end

    should "display correct checkbox html as unchecked when object value doesn't match" do
      @user.stubs(:show_favorites => 'alien')
      actual_html = standard_builder(@user).check_box(:show_favorites, :value => 'human')
      assert_has_no_tag('input[type=checkbox]', :checked => 'checked') { actual_html }
    end

    should "display correct checkbox html as unchecked when object value is false" do
      @user.stubs(:show_favorites => false)
      actual_html = standard_builder(@user).check_box(:show_favorites, :value => '1')
      assert_has_no_tag('input[type=checkbox]', :checked => 'checked') { actual_html }
    end

    should "display correct unchecked hidden field when specified" do
      actual_html = standard_builder(@user).check_box(:show_favorites, :value => 'female', :uncheck_value => 'false')
      assert_has_tag('input[type=hidden]', :name => 'user[show_favorites]', :value => 'false') { actual_html }
    end

    should "display correct checkbox in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo input[type=checkbox]', :checked => 'checked', :id => 'markup_user_remember_me', :name => 'markup_user[remember_me]'){result}
    end

    should "display correct checkbox in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo input[type=checkbox]', :checked => 'checked', :id => 'markup_user_remember_me', :name => 'markup_user[remember_me]'){result}
    end
  end

  context 'for #radio_button method' do
    should "display correct radio button html" do
      actual_html = standard_builder(@user).radio_button(:gender, :value => 'male', :class => 'large')
      assert_has_tag('input.large[type=radio]', :id => 'user_gender_male', :name => 'user[gender]', :value => 'male') { actual_html }
    end

    should "display correct radio button html when checked" do
      actual_html = standard_builder(@user).radio_button(:gender, :checked => true)
      assert_has_tag('input[type=radio]', :checked => 'checked', :name => 'user[gender]') { actual_html }
    end

    should "display correct radio button html as checked when object value matches" do
      @user.stubs(:gender => 'male')
      actual_html = standard_builder.radio_button(:gender, :value => 'male')
      assert_has_tag('input[type=radio]', :checked => 'checked', :name => 'user[gender]') { actual_html }
    end

    should "display correct radio button html as unchecked when object value doesn't match" do
      @user.stubs(:gender => 'male')
      actual_html = standard_builder.radio_button(:gender, :value => 'female')
      assert_has_no_tag('input[type=radio]', :checked => 'checked') { actual_html }
    end

    should "display correct radio button in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo input[type=radio]', :id => 'markup_user_gender_male', :name => 'markup_user[gender]', :value => 'male'){result}
      assert_has_selector('#demo input[type=radio]', :id => 'markup_user_gender_female', :name => 'markup_user[gender]', :value => 'female'){result}
      assert_has_selector('#demo input[type=radio][checked=checked]', :id => 'markup_user_gender_male'){result}
    end

    should "display correct radio button in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo input[type=radio]', :id => 'markup_user_gender_male', :name => 'markup_user[gender]', :value => 'male'){result}
      assert_has_selector('#demo input[type=radio]', :id => 'markup_user_gender_female', :name => 'markup_user[gender]', :value => 'female'){result}
      assert_has_selector('#demo input[type=radio][checked=checked]', :id => 'markup_user_gender_male'){result}
    end
  end

  context 'for #text_area method' do
    should "display correct text_area html" do
      actual_html = standard_builder.text_area(:about, :class => 'large')
      assert_has_tag('textarea.large', :id => 'user_about', :name => 'user[about]') { actual_html }
    end

    should "display correct text_area in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'user-about'){result}
      assert_has_selector('#demo2 textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'textarea'){result}
    end

    should "display correct text_area in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'user-about'){result}
      assert_has_selector('#demo2 textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'textarea'){result}
    end
  end

  context 'for #password_field method' do
    should "display correct password_field html" do
      actual_html = standard_builder.password_field(:code, :class => 'large')
      assert_has_tag('input.large[type=password]', :id => 'user_code', :name => 'user[code]') { actual_html }
    end

    should "display correct password_field in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo input', :type => 'password', :class => 'user-password', :value => 'secret'){result}
      assert_has_selector('#demo2 input', :type => 'password', :class => 'input', :name => 'markup_user[code]'){result}
    end

    should "display correct password_field in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo input', :type => 'password', :class => 'user-password', :value => 'secret'){result}
      assert_has_selector('#demo2 input', :type => 'password', :class => 'input', :name => 'markup_user[code]'){result}
    end
  end

  context 'for #file_field method' do
    should "display correct file_field html" do
      actual_html = standard_builder.file_field(:photo, :class => 'large')
      assert_has_tag('input.large[type=file]', :id => 'user_photo', :name => 'user[photo]') { actual_html }
    end

    should "display correct file_field in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo  input.user-photo', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'){result}
      assert_has_selector('#demo2 input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'){result}
    end

    should "display correct file_field in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo  input.user-photo', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'){result}
      assert_has_selector('#demo2 input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'){result}
    end
  end

  context 'for #select method' do
    should "display correct select html" do
      actual_html = standard_builder.select(:state, :options => ['California', 'Texas', 'Wyoming'], :class => 'selecty')
      assert_has_tag('select.selecty', :id => 'user_state', :name => 'user[state]') { actual_html }
      assert_has_tag('select.selecty option', :count => 3) { actual_html }
      assert_has_tag('select.selecty option', :value => 'California', :content => 'California') { actual_html }
      assert_has_tag('select.selecty option', :value => 'Texas',      :content => 'Texas')      { actual_html }
      assert_has_tag('select.selecty option', :value => 'Wyoming',    :content => 'Wyoming')    { actual_html }
    end

    should "display correct select html with selected item if it matches value" do
      @user.stubs(:state => 'California')
      actual_html = standard_builder.select(:state, :options => ['California', 'Texas', 'Wyoming'])
      assert_has_tag('select', :id => 'user_state', :name => 'user[state]') { actual_html }
      assert_has_tag('select option', :selected => 'selected', :count => 1) { actual_html }
      assert_has_tag('select option', :value => 'California', :selected => 'selected') { actual_html }
    end

    should "display correct select html with include_blank" do
      actual_html = standard_builder.select(:state, :options => ['California', 'Texas', 'Wyoming'], :include_blank => true)
      assert_has_tag('select', :id => 'user_state', :name => 'user[state]') { actual_html }
      assert_has_tag('select option', :count => 4) { actual_html }
      assert_has_tag('select option:first-child', :content => '') { actual_html }
    end

    should "display correct select html with collection passed in" do
      actual_html = standard_builder.select(:role, :collection => @user.role_types, :fields => [:name, :id])
      assert_has_tag('select', :id => 'user_role', :name => 'user[role]') { actual_html }
      assert_has_tag('select option', :count => 3) { actual_html }
      assert_has_tag('select option', :value => '1', :content => 'Admin', :selected => 'selected')     { actual_html }
      assert_has_tag('select option', :value => '2', :content => 'Moderate')  { actual_html }
      assert_has_tag('select option', :value => '3', :content => 'Limited')   { actual_html }
    end

    should "display correct select in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'user-about'){result}
      assert_has_selector('#demo2 textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'textarea'){result}
    end

    should "display correct select in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'user-about'){result}
      assert_has_selector('#demo2 textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'textarea'){result}
    end
  end

  context 'for #submit method' do
    should "display correct submit button html with no options" do
      actual_html = standard_builder.submit
      assert_has_tag('input[type=submit]', :value => "Submit") { actual_html }
    end

    should "display correct submit button html" do
      actual_html = standard_builder.submit("Commit", :class => 'large')
      assert_has_tag('input.large[type=submit]', :value => "Commit") { actual_html }
    end

    should "display correct submit button in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo input', :type => 'submit', :id => 'demo-button', :class => 'success'){result}
      assert_has_selector('#demo2 input', :type => 'submit', :class => 'button', :value => "Create"){result}
    end

    should "display correct submit button in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo input', :type => 'submit', :id => 'demo-button', :class => 'success'){result}
      assert_has_selector('#demo2 input', :type => 'submit', :class => 'button', :value => "Create"){result}
    end
  end

  context 'for #image_submit method' do
    should "display correct image submit button html with no options" do
      actual_html = standard_builder.image_submit('buttons/ok.png')
      assert_has_tag('input[type=image]', :src => "/images/buttons/ok.png") { actual_html }
    end

    should "display correct image submit button html" do
      actual_html = standard_builder.image_submit('/system/ok.png', :class => 'large')
      assert_has_tag('input.large[type=image]', :src => "/system/ok.png") { actual_html }
    end

    should "display correct image submit button in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo input', :type => 'image', :id => 'image-button', :src => '/images/buttons/post.png'){result}
      assert_has_selector('#demo2 input', :type => 'image', :class => 'image', :src => "/images/buttons/ok.png"){result}
    end

    should "display correct image submit button in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo input', :type => 'image', :id => 'image-button', :src => '/images/buttons/post.png'){result}
      assert_has_selector('#demo2 input', :type => 'image', :class => 'image', :src => "/images/buttons/ok.png"){result}
    end
  end

  # ===========================
  # StandardFormBuilder
  # ===========================

  context 'for #text_field_block method' do
    should "display correct text field block html" do
      actual_html = standard_builder.text_field_block(:first_name, :class => 'large', :caption => "FName")
      assert_has_tag('p label', :for => 'user_first_name', :content => "FName: ") { actual_html }
      assert_has_tag('p input.large[type=text]', :value => "Joe", :id => 'user_first_name', :name => 'user[first_name]') { actual_html }
    end

    should "display correct text field block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p label', :for => 'markup_user_username', :content => "Nickname: ", :class => 'label'){result}
      assert_has_selector('#demo2 p input', :type => 'text', :name => 'markup_user[username]', :id => 'markup_user_username'){result}
    end

    should "display correct text field block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p label', :for => 'markup_user_username', :content => "Nickname: ", :class => 'label'){result}
      assert_has_selector('#demo2 p input', :type => 'text', :name => 'markup_user[username]', :id => 'markup_user_username'){result}
    end
  end

  context 'for #text_area_block method' do
    should "display correct text area block html" do
      actual_html = standard_builder.text_area_block(:about, :class => 'large', :caption => "About Me")
      assert_has_tag('p label', :for => 'user_about', :content => "About Me: ") { actual_html }
      assert_has_tag('p textarea', :id => 'user_about', :name => 'user[about]') { actual_html }
    end

    should "display correct text area block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p label', :for => 'markup_user_about', :content => "About: "){result}
      assert_has_selector('#demo2 p textarea', :name => 'markup_user[about]', :id => 'markup_user_about'){result}
    end

    should "display correct text area block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p label', :for => 'markup_user_about', :content => "About: "){result}
      assert_has_selector('#demo2 p textarea', :name => 'markup_user[about]', :id => 'markup_user_about'){result}
    end
  end

  context 'for #password_field_block method' do
    should "display correct password field block html" do
      actual_html = standard_builder.password_field_block(:keycode, :class => 'large', :caption => "Code")
      assert_has_tag('p label', :for => 'user_keycode', :content => "Code: ") { actual_html }
      assert_has_tag('p input.large[type=password]', :id => 'user_keycode', :name => 'user[keycode]') { actual_html }
    end

    should "display correct password field block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p label', :for => 'markup_user_code', :content => "Code: "){result}
      assert_has_selector('#demo2 p input', :type => 'password', :name => 'markup_user[code]', :id => 'markup_user_code'){result}
    end

    should "display correct password field block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p label', :for => 'markup_user_code', :content => "Code: "){result}
      assert_has_selector('#demo2 p input', :type => 'password', :name => 'markup_user[code]', :id => 'markup_user_code'){result}
    end
  end

  context 'for #file_field_block method' do
    should "display correct file field block html" do
      actual_html = standard_builder.file_field_block(:photo, :class => 'large', :caption => "Photo")
      assert_has_tag('p label', :for => 'user_photo', :content => "Photo: ") { actual_html }
      assert_has_tag('p input.large[type=file]', :id => 'user_photo', :name => 'user[photo]') { actual_html }
    end

    should "display correct file field block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p label', :for => 'markup_user_photo', :content => "Photo: "){result}
      assert_has_selector('#demo2 p input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'){result}
    end

    should "display correct file field block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p label', :for => 'markup_user_photo', :content => "Photo: "){result}
      assert_has_selector('#demo2 p input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'){result}
    end
  end

  context 'for #check_box_block method' do
    should "display correct check box block html" do
      actual_html = standard_builder.check_box_block(:remember_me, :class => 'large', :caption => "Remember session")
      assert_has_tag('p label', :for => 'user_remember_me', :content => "Remember session: ") { actual_html }
      assert_has_tag('p input.large[type=checkbox]', :id => 'user_remember_me', :name => 'user[remember_me]') { actual_html }
    end

    should "display correct check box block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p label', :for => 'markup_user_remember_me', :content => "Remember Me: "){result}
      assert_has_selector('#demo2 p input.checker', :type => 'checkbox', :name => 'markup_user[remember_me]'){result}
    end

    should "display correct check box block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p label', :for => 'markup_user_remember_me', :content => "Remember Me: "){result}
      assert_has_selector('#demo2 p input.checker', :type => 'checkbox', :name => 'markup_user[remember_me]'){result}
    end
  end

  context 'for #select_block method' do
    should "display correct select_block block html" do
      actual_html = standard_builder.select_block(:country, :options => ['USA', 'Canada'], :class => 'large', :caption => "Your country")
      assert_has_tag('p label', :for => 'user_country', :content => "Your country: ") { actual_html }
      assert_has_tag('p select', :id => 'user_country', :name => 'user[country]') { actual_html }
      assert_has_tag('p select option', :content => 'USA')   { actual_html }
      assert_has_tag('p select option', :content => 'Canada') { actual_html }
    end

    should "display correct select_block block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p label', :for => 'markup_user_state', :content => "State: "){result}
      assert_has_selector('#demo2 p select', :name => 'markup_user[state]', :id => 'markup_user_state'){result}
      assert_has_selector('#demo2 p select option',  :content => 'California'){result}
      assert_has_selector('#demo2 p select option',  :content => 'Texas'){result}
    end

    should "display correct select_block block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p label', :for => 'markup_user_state', :content => "State: "){result}
      assert_has_selector('#demo2 p select', :name => 'markup_user[state]', :id => 'markup_user_state'){result}
    end
  end

  context 'for #submit_block method' do
    should "display correct submit block html" do
      actual_html = standard_builder.submit_block("Update", :class => 'large')
      assert_has_tag('p input.large[type=submit]', :value => 'Update') { actual_html }
    end

    should "display correct submit block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p input', :type => 'submit', :class => 'button'){result}
    end

    should "display correct submit block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p input', :type => 'submit', :class => 'button'){result}
    end
  end

  context 'for #image_submit_block method' do
    should "display correct image submit block html" do
      actual_html = standard_builder.image_submit_block("buttons/ok.png", :class => 'large')
      assert_has_tag('p input.large[type=image]', :src => '/images/buttons/ok.png') { actual_html }
    end

    should "display correct image submit block in haml" do
      result = render("form_for.haml")
      assert_has_selector('#demo2 p input', :type => 'image', :class => 'image', :src => '/images/buttons/ok.png'){result}
    end

    should "display correct image submit block in erb" do
      result = render("form_for.erb")
      assert_has_selector('#demo2 p input', :type => 'image', :class => 'image', :src => '/images/buttons/ok.png'){result}
    end
  end
end
