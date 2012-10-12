# A small Domain Specific Language for testing admin sections of the website
# and doing whatever else might be useful
module IntegrationDsl
  def is_redirected_to(template, from = 'unknown: update test!')
    assert_response :redirect, "Did not redirect from #{from.to_s} successfully."
    follow_redirect!
    assert_response :success
    assert_template(template)
  end

  def attempts_login(name, password, allowed = true)
    post '/admin/login', 'user[name]' => name, 'user[password]' => password
    if allowed
      assert session[:user]
      is_redirected_to('admin/admin/index')
    else
      assert_template('admin/admin/login')
      assert !flash[:notice].nil?
      assert session[:user].nil?
    end
  end
  
  def login_as_admin
    attempts_login('memyself', 'ar5ecr1sps')
  end
  
  def attempts_get(url, allowed = true)
    get url
    if allowed
      assert_response :success
    else
      is_redirected_to('admin/admin/login', url)
    end
  end
end