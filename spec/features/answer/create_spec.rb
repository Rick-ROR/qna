require 'rails_helper'

feature 'User can answer the question', %q(
  I would like to answer the question,
  as an authenticated user
) do

  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'Body', with: 'user answer'
      click_on 'Reply'

      expect(page).to have_content 'user answer'
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer the question with attached file', js: true do
      fill_in 'Body', with: 'text text text'
      attach_file 'Files', [file_fixture("Ellesmere.rom"), file_fixture("yxMwBrJfQTY.jpg")]

      click_on 'Reply'
      expect(page).to have_link 'Ellesmere.rom'
      expect(page).to have_link 'yxMwBrJfQTY.jpg'
    end

  end

  scenario 'Unauthenticated user tries to answers the question' do
    visit question_path(question)
    fill_in 'Body', with: 'user answer'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
