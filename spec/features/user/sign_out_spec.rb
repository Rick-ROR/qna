require 'rails_helper'

feature 'User can sign out', %q(
  I want to sign out
) do

  scenario 'Authenticated user tries to sign out' do
    sign_in(create(:user))

    click_on 'Log out'
    expect(page).to have_content('Signed out successfully.')
  end
end
