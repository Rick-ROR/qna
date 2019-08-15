require 'rails_helper'

feature 'User can view his rewards', %q{
  I'd like to see my award for the best answer to the question
  I'd like to see all my awards
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, author: user) }
  given(:reward) { create(:reward, :with_image, question: question) }

  background do
    sign_in(user)
  end

  scenario 'user sees his reward for the question', js: true do
    # WTF? почему нужно перезагружать reward чтобы награда появилась
    reward.reload
    # p reward
    # update: я понял, пока reward не вызван его и нету, тк это МЕТОД, который запоминает данные
    # и отличие given! от given, не только в том что обычный создаёт данные один раз и запоминает,
    # а и в том что given! ещё сам выполняется перед тестом и данные уже есть

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
