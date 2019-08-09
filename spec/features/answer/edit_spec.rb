require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
}	do

  given(:user_author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user_author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page) .to_not have_link 'Edit'
  end

  describe 'Authenticated user'	do
    background do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      within('.question_answers') do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer to attach files', js: true do
      within('.question_answers') do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within('.question_answers') do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      someones_answer = create(:answer, question: question)
      visit current_path

      within("#answer-#{someones_answer.id}") do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end

