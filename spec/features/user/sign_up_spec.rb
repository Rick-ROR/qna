require 'rails_helper'

feature 'User can sign up', %q(
  In order to ask questions and answers
  I'd like to be able to sign up
) do

  background do
    visit root_path
    click_on 'Sign up'
  end

  scenario 'User successfully signs up' do
    fill_in 'Email', with: 'user@example.edu'
    fill_in 'Password', with: 'fluency'
    fill_in 'Password confirmation', with: 'fluency'
    within('form') { click_on 'Sign up' }

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User unsuccessfully signs up' do
    fill_in 'Email', with: 'user@example.edu'
    fill_in 'Password', with: 'fluency'
    fill_in 'Password confirmation', with: 'goooooo'
    within('form') { click_on 'Sign up' }

    expect(page).to have_css '#error_explanation'
  end
end
