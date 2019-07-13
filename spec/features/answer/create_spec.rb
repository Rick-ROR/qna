require 'rails_helper'

feature 'User can answer the question', %q(
  I would like to answer the question
) do

  given(:question) { create(:question) }

  scenario 'answers the question' do
    visit question_path(question)

    fill_in 'Body', with: 'user answer'
    click_on 'Reply'

    expect(page).to have_content 'user answer'
  end
end
