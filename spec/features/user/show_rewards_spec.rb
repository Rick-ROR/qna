require 'rails_helper'

feature 'User can view his rewards', %q{
  I'd like to see my award for the best answer to the question
  I'd like to see all my awards
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, author: user) }
  given(:reward) { create(:reward, :with_file, question: question) }

  background do
    sign_in(user)
  end

  scenario 'user sees his reward for the question', js: true do
    # WTF? почему нужно перезагружать reward чтобы награда появилась 
    reward.reload

    visit question_path(question)

    within('.question_box') do
      click_on reward.title
    end

    expect(page).to have_content reward.title
    expect(page).to have_content question.title
    expect(page).to have_css("img[src*=\"#{reward.image.filename}\"]")
  end

  scenario 'user sees his all rewards', js: true do

    reward.update(answer: answer)

    visit user_rewards_path(user)

    expect(page).to have_content reward.title
    expect(page).to have_content question.title
    expect(page).to have_css("img[src*=\"#{reward.image.filename}\"]")
  end

end
