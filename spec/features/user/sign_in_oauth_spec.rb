require 'rails_helper'

feature 'User can sign in with OAuth providers', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in through OAuth providers
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'User tries to sign up with oauth Github' do
    user_email = "github_user@example.edu"
    mock_auth_hash(provider: 'github', email: user_email)

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'You have to confirm your email address before continuing.'

    open_email user_email
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'User tries to sign up with oauth VK' do
    user_email = "vk_user@example.edu"
    mock_auth_hash(provider: 'vkontakte', email: user_email)

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'You have to confirm your email address before continuing.'

    open_email user_email
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
  end

  scenario 'User tries to sign up with oauth VK w/o email' do
    mock_auth_hash(provider: 'vkontakte')
    user_email = "ascending_divers@example.edu"

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'To register, you must specify and confirm the email address:'

    fill_in 'oauth_email', with: user_email
    within('form') { click_on 'Receive Email' }
    expect(page).to have_content "Check #{user_email} and confirm your email address before continuing."

    open_email user_email
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
  end

  scenario 'User tries to sign up with oauth VK w/o email and enter invalid email' do
    mock_auth_hash(provider: 'vkontakte')
    user_email = "0919"

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'To register, you must specify and confirm the email address:'

    fill_in 'oauth_email', with: user_email
    within('form') { click_on 'Receive Email' }

    expect(page).to have_content 'You entered the wrong email format!'
    expect(page).to have_field('oauth_email')
  end

  scenario 'User tries to sign in with oauth VK' do
    auth = mock_auth_hash(provider: 'vkontakte')
    create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

    visit new_user_session_path
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
  end
end
