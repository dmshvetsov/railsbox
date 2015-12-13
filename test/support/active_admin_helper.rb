module ActiveAdminHelper

  def submit_form
    find('input[type="submit"]').click
  end

  def admin_login user
    visit '/admin'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    submit_form

    current_path.must_equal '/admin', 'Login failed'
    page.must_have_content 'Signed in successfully.'
  end

  def dialog_confirm
    within '.active_admin_dialog' do
      click_button('OK')
    end
  end

  def dialog_cancel
    within '.active_admin_dialog' do
      click_button('Cancel')
    end
  end

end
