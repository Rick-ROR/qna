require 'rails_helper'

feature 'User can vote for the question', %q{
  I'd like to be able to vote on questions from other users;
  I'd like to be able to re-vote;
  User can vote only once for/against in a row;
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe "Authenticated user" do
    context 'not author of question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User voteup for the question', js: true do
        within('.question_box') do
          expect(page).to have_link nil, href: "/questions/#{question.id}/vote?vote=1"

          click_on(class: 'voteup')
          expect(page).to have_content 'Rating: 1'
        end
      end

      scenario 'User votedown for the question', js: true do
        within('.question_box') do
          expect(page).to have_link nil, href: "/questions/#{question.id}/vote?vote=-1"

          find('a.votedown').click
          expect(page).to have_content 'Rating: -1'
        end
      end
    end


    context 'author of question' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'trying to vote', js: true do
        within('.question_box') do
          expect(page).to have_no_selector("voteup")
          expect(page).to have_no_selector("votedown")
        end
      end
    end
  end


  describe "Unauthenticated user" do
    scenario 'trying to vote', js: true do
      visit question_path(question)

      within('.question_box') do
        expect(page).to have_no_selector("voteup")
        expect(page).to have_no_selector("votedown")
      end
    end
  end

end
