require 'rails_helper'

feature 'User can add reward to question for best answer', %q{
  As the author of the question, I would like to reward for the best answer
  I'd like to be add a title to the reward
  I'd like to be add a image to the reward
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'User adding reward when asks question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within (".nested_reward") do
      fill_in 'Reward title', with: '300IQ'
      attach_file 'Image', file_fixture("yxMwBrJfQTY.jpg")
    end

    click_on 'Ask'

    expect(page).to have_content '300IQ'
  end

end
