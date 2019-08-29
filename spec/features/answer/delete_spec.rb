require 'rails_helper'

feature 'User can delete his answer', %q(
  As an author of the answer
  I would like to be able to delete my answer
) do

  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }

  describe 'Authenticated user' do
    background do
      sign_in(user_author)
    end

    scenario 'can delete his answer', js: true do
      answer = create(:answer, question: question, author: user_author)
      visit question_path(question)

      page.accept_confirm do
        within('.answer_actions') { click_link 'Delete' }
      end

      expect(page).to have_no_content answer.body
    end

    scenario 'wants to delete another user answer' do
      create(:answer, question: question)
      visit question_path(question)

      within('.answer') do
        expect(page).to have_no_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    create(:answer, question: question)
    visit question_path(question)

    within('.answer') do
      expect(page).to have_no_link 'Delete'
    end
  end

end
