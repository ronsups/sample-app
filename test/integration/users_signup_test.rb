require 'test_helper'

# comment
class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  '',
                                         email: 'user@invalid',
                                         password:              'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  'Example User',
                                         email: 'user@example.com',
                                         password:              'password',
                                         password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test 'error messages on invalid signup' do
    get signup_path
    post users_path, params: { user: { name:  '',
                                       email: 'user@invalid',
                                       password:              'foo',
                                       password_confirmation: 'bar' } }
    assert_select "div[id='error_explanation']"
    assert_select "div[class='alert alert-danger']"
    assert_select "form[action='/signup']"
  end

  test 'no error messages on valid signup' do
    get signup_path
    post users_path, params: { user: { name:  'abcd',
                                       email: 'user@valid.com',
                                       password:              'foo1234',
                                       password_confirmation: 'foo1234' } }
    follow_redirect!
    assert_select "div[id='error_explanation']", false
    assert_select "section[class='user_info']"
    assert_select "div[class='alert alert-success']",
                  'Welcome to the Sample App!'
  end
end
