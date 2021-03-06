require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe "Authenticated user" do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'Files', [file_fixture("Ellesmere.rom"), file_fixture("yxMwBrJfQTY.jpg")]

      click_on 'Ask'
      expect(page).to have_link 'Ellesmere.rom'
      expect(page).to have_link 'yxMwBrJfQTY.jpg'
    end
  end

  describe 'multiple session', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit new_question_path
      end

      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to have_no_content 'Жизнь подражает Искусству в гораздо большей степени, чем Искусство подражает Жизни.'
      end

      Capybara.using_session('user') do

        fill_in 'Title', with: 'Жизнь подражает Искусству в гораздо большей степени, чем Искусство подражает Жизни.'
        fill_in 'Body', with: 'multiple session'
        click_on 'Ask'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Жизнь подражает Искусству в гораздо большей степени, чем Искусство подражает Жизни.'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    expect(page).to have_no_link 'Ask question'
  end
end
