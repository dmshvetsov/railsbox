module ActiveAdminHelper

  def submit_form
    find('input[type="submit"]').click
  end

  def admin_login user
    visit '/admin'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    submit_form

    current_path.must_equal '/admin'
    page.must_have_content 'Signed in successfully.'
  end

end
