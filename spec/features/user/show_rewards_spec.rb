require 'rails_helper'

feature 'User can view his rewards', %q{
  I'd like to see my award for the best answer to the question
  I'd like to see all my awards
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:reward) { create(:reward, :with_image, question: question) }
  given(:author_best) { create(:user) }
  given!(:answer) { create(:answer, question: question, author: author_best) }

  scenario 'user sees reward for the question', js: true do

    sign_in(author_best)

    visit question_path(question)

    within('.question_box') do
      click_on reward.title
    end

    expect(page).to have_content reward.title
    expect(page).to have_content question.title
    expect(page).to have_css("img[src*=\"#{reward.image.filename}\"]")
  end

  scenario 'user sees his all rewards', js: true do
    sign_in(user)
    visit question_path(question)

    within(:css, "li#answer-#{answer.id}") do
      click_on 'make best?'
    end

    sign_out
    sign_in(author_best)
    visit user_rewards_path(author_best)

    expect(page).to have_content reward.title
    expect(page).to have_content question.title
    expect(page).to have_css("img[src*=\"#{reward.image.filename}\"]")
  end

end
