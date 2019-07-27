require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
}	do

  given(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }

  scenario 'Unauthenticated can not edit question' do

  end


  describe 'Authenticated user'	do

    background do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      # save_and_open_page
      within('.question_box') do
        click_on 'Edit'
        fill_in 'Title', with: 'edited Title'
        fill_in 'Body', with: 'edited Body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited Title'
        expect(page).to have_content 'edited Body'
        expect(page).to_not have_selector 'form'
      end


    end

    scenario 'edits his question with errors', js: true do

    end

    scenario "tries to edit other user's question" do

    end

  end

end
