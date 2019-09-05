require 'rails_helper'

feature 'user can leave a comment on the question', %q{
  I'd like to be able leave clarifying comments;
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User adding comment', js: true do
      within('.question_box') do
        fill_in 'comment_body', with: 'another chance'
        click_on 'Reply'
        expect(page).to have_content 'another chance'
      end

    end

  end

end
