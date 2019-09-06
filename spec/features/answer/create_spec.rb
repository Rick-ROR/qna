require 'rails_helper'

feature 'User can answer the question', %q(
  I would like to answer the question,
  as an authenticated user
) do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      within('form.new-answer') do
        fill_in 'Body', with: 'user answer'
        click_on 'Reply'
      end

      expect(page).to have_content 'user answer'
    end

    scenario 'answers the question with errors', js: true do
      within('form.new-answer') do
        click_on 'Reply'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer the question with attached file', js: true do
      within('form.new-answer') do
        fill_in 'Body', with: 'text text text'
        attach_file 'Files', [file_fixture("Ellesmere.rom"), file_fixture("yxMwBrJfQTY.jpg")]

        click_on 'Reply'
      end
      expect(page).to have_link 'Ellesmere.rom'
      expect(page).to have_link 'yxMwBrJfQTY.jpg'
    end

  end

  describe 'multiple session', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('form.new-answer') do
          fill_in 'Body', with: 'Искусство подражает жизни, жизнь тоже может подражать искусству'
          click_on 'Reply'
        end

        within '.question_answers' do
          expect(page).to have_content 'Искусство подражает жизни, жизнь тоже может подражать искусству'
        end
      end

      Capybara.using_session('guest') do
        within '.question_answers' do
          expect(page).to have_content 'Искусство подражает жизни, жизнь тоже может подражать искусству'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to answers the question' do
    expect(page).to have_no_selector("new-answer")
  end
end
