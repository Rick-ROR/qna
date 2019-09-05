require 'rails_helper'

feature 'user can leave a comment on the question', %q{
  I'd like to be able leave clarifying comments;
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User adding comment', js: true do
      within('.question_box') do
        fill_in 'comment_body', with: 'another chance'
        click_on 'Reply'
        expect(page).to have_content 'another chance'
      end
    end
  end

  scenario 'Unauthenticated user tries to comment the question' do
    visit question_path(question)
    within("#comments-question-#{question.id}") do
      expect(page).to have_no_selector("new-comment")
    end
  end

  describe 'multiple session', js: true do
    given(:comm) { 'правда молчит и ждёт своего времени' }

    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_no_content comm
      end

      Capybara.using_session('user') do
        within("#comments-question-#{question.id}") do
          fill_in 'comment_body', with: comm
          click_on 'Reply'

          expect(page).to have_content comm
        end
      end

      Capybara.using_session('guest') do
        within("#comments-question-#{question.id}") do
          expect(page).to have_content comm
        end
      end
    end
  end

end
