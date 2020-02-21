require 'sphinx_helper'

feature 'user can search on the site', %q{
  As an user
  I'd like to be able to search on site materials
  I'd like to be able on select resource to search
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }
  given!(:comment) { create(:comment, commentable: answer, author: user) }

  before { visit root_path }

  scenario 'search anything found all materials of the site', js: true, sphinx: true do

    ThinkingSphinx::Test.run do

      fill_in 'query', with: ''
      click_on 'go'

      expect(page).to have_content "Results found 4"
      expect(page).to have_content question.body
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end

  context 'search word by all materials of the site' do
    given!(:user_poly) { create(:user, email: 'Polynation@example.edu' ) }
    given!(:question_poly) { create(:question, author: user_poly, body: 'Polynation' ) }
    given!(:answer_poly) { create(:answer, author: user_poly, body: 'Polynation') }
    given!(:comment_poly) { create(:comment, author: user_poly, commentable: answer_poly, body: 'Polynation') }

    scenario 'finds records only matching the search word', js: true, sphinx: true do
      ThinkingSphinx::Test.run do

        fill_in 'query', with: "Polynation"
        click_on 'go'

        expect(page).to have_content "Results found 4"
        expect(page).to have_content "Polynation"
        expect(page).to have_content user_poly.email

        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.body
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'search by questions', js: true, sphinx: true do
    ThinkingSphinx::Test.run do

      select 'by questions', from: 'scope'
      fill_in 'query', with: ''
      click_on 'go'

      expect(page).to have_content question.body

      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'search by answers', js: true, sphinx: true do
    ThinkingSphinx::Test.run do

      select 'by answers', from: 'scope'
      fill_in 'query', with: ''
      click_on 'go'

      expect(page).to have_content answer.body

      expect(page).to_not have_content question.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'search by comments', js: true, sphinx: true do
    ThinkingSphinx::Test.run do

      select 'by comments', from: 'scope'
      fill_in 'query', with: ''
      click_on 'go'

      expect(page).to have_content comment.body

      expect(page).to_not have_content question.body
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'search by users', js: true, sphinx: true do
    ThinkingSphinx::Test.run do

      select 'by users', from: 'scope'
      fill_in 'query', with: ''
      click_on 'go'

      expect(page).to have_content user.email

      expect(page).to_not have_content question.body
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
    end
  end
end
