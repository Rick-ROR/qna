require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'User tries to sign in with oauth Github' do
    user_email = mock_auth_hash(:github).info.email

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'You have to confirm your email address before continuing.'

    open_email user_email
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'User tries to sign in with oauth VK' do
    user_email = mock_auth_hash(:vkontakte).info.email

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'You have to confirm your email address before continuing.'

    open_email user_email
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from VK account.'
  end

  scenario 'User tries to sign in with oauth VK w/o email' do
    skip
    mock_auth_hash(:vkontakte, true)

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from VK account.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
