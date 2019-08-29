require 'rails_helper'

feature 'User can vote for the answer', %q{
  I'd like to be able to vote on answers from other users;
  I'd like to be able to re-vote;
  User can vote only once for/against in a row;
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe "Authenticated user" do
    context 'not author of answer' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User voteup for the answer', js: true do
        within('.question_answers') do
          expect(page).to have_link nil, href: "/answers/#{answer.id}/vote?vote=true"

          click_on(class: 'voteup')
          expect(page).to have_content 'Rating: 1'
        end
      end

      scenario 'User votedown for the answer', js: true do
        within('.question_answers') do
          expect(page).to have_link nil, href: "/answers/#{answer.id}/vote?vote=false"

          find('a.votedown').click
          expect(page).to have_content 'Rating: -1'
        end
      end
    end


    context 'author of answer' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'trying to vote', js: true do
        within('.question_answers') do
          expect(page).to have_no_selector("voteup")
          expect(page).to have_no_selector("votedown")
        end
      end
    end
  end


  describe "Unauthenticated user" do
    scenario 'trying to vote', js: true do
      visit question_path(question)

      within('.question_answers') do
        expect(page).to have_no_selector("voteup")
        expect(page).to have_no_selector("votedown")
      end
    end
  end

end
