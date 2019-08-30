require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
}	do

  given(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    within('.question_box') do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user'	do

    background do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
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

    scenario 'edits his question to attach files', js: true do
      within('.question_box') do
        click_on 'Edit'
        attach_file 'Files', [file_fixture("Ellesmere.rom"), file_fixture("yxMwBrJfQTY.jpg")]
        click_on 'Save'

        expect(page).to have_link 'Ellesmere.rom'
        expect(page).to have_link 'yxMwBrJfQTY.jpg'
      end
    end

    scenario 'edits his question with errors', js: true do
      within('.question_box') do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      someones_question = create(:question)
      visit question_path(someones_question)

      within('.question_box') do
        expect(page).to_not have_link 'Edit'
      end
    end

  end

end
