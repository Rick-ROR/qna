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
      within(:css, "li#answer-#{answer.id}") do
        expect(page).to have_content answer.body

        click_on 'make best?'
        expect(page).to have_content('This is better answer!')
      end

      expect(page).to have_content('This is better answer!', count: 1)
      expect(page.find('ul.question_answers > li', match: :first)[:id]).to eq("answer-#{answer.id}")
      expect(page).to have_tag("ul.question_answers > li:first-child#answer-#{answer.id}", text: answer.body)
      #
      expect(page.find('ul.question_answers', match: :first)).to have_content answer.body
      expect(page.find('ul.question_answers > li:first-child')).to have_content answer.body
      expect(page.first('ul.question_answers > li')).to have_content answer.body
    end

    scenario 'can re-select the best answer', js: true do

      within(:css, "li#answer-#{answers.first.id}") do
        click_on 'make best?'
        expect(page).to have_content('This is better answer!')
      end

      within(:css, "li#answer-#{answers.last.id}") do
        click_on 'make best?'
        expect(page).to have_content('This is better answer!')
      end

      expect(page).to have_content('This is better answer!', count: 1)
      expect(page.find('ul.question_answers', match: :first)).to have_content answers.last.body
    end

  end

  describe 'not Author of the question' do

    def check_link
      answer = answers.first
      within(:css, "li#answer-#{answer.id}") do
        expect(page).to have_content answer.body
        expect(page).to_not have_link 'make best?'
      end
    end

    scenario "tries to select for the best answer" do
      sign_in(create(:user))
      visit question_path(question)
      check_link
    end

    scenario "tries to select for the best answer w/o SignIn" do
      visit question_path(question)
      check_link
    end

  end

end
