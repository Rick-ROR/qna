require 'rails_helper'

feature 'Author of the question can vote for the best answer', %q{
  The author can re-select the best answer
}	do

  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answers) { create_list(:answer, 4, question: question) }

  describe 'Author of the question' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can select for the best answer', js: true do

      answer = answers.first
      # within("#answer-#{answer.id}") do
      within(:css, "li#answer-#{answer.id}") do
        expect(page).to have_content answer.body
        check 'best'

        visit current_path
        assert page.has_checked_field?('best')
        # ++
        # expect(page).to  have_checked_field('#best')
        # save_and_open_page
        # ++
        # expect(page.find("input#best")).to be_checked
      end
    end

  end

end
