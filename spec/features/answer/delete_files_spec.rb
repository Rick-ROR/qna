require 'rails_helper'

feature 'User can delete files from his answer', %q{
  If he uploaded the wrong file or it has lost relevance
}	do
  given(:user_author) { create(:user) }
  given(:question) { create(:question, :with_file, author: user_author) }
  given!(:answer) { create(:answer, :with_file, question: question, author: user_author) }

  scenario 'Unauthenticated can\'t delete file' do
    visit question_path(question)

    within '.answer ul.attached_files' do
      expect(page).to_not have_link 'Delete'
    end
  end

  context 'Authenticated user'	do
    background do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'can delete file', js: true do
      file = answer.files.first.filename.to_s

      within '.answer ul.attached_files' do
        expect(page).to have_content file
        page.accept_confirm { click_link 'Delete' }
      end

      within '.answer' do
        expect(page).to_not have_content file
      end
    end

    scenario 'not the author of answer is trying to delete file' do
      answer = create(:answer, :with_file, question: question, author: create(:user))
      visit current_path

      within "li#answer-#{answer.id} ul.attached_files" do
        expect(page).to have_no_link 'Delete'
      end
    end

  end
end
