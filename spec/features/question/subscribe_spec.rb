require 'rails_helper'

feature 'User can subscribe on question', %q{
  To receive notifications about new answers to a question
  As an authenticated user
  I'd like to be able to subscribe to the question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User subscribe on question', js: true do
      within('.question_box') do
        expect(page).to have_checked_field "subscribe"

        page.check("subscribe")
        find('subscribe').should be_checked
      end
    end

  end

  describe "Unauthenticated user" do
    scenario 'trying to subscribe', js: true do
      visit question_path(question)

      within('.question_box') do
        expect(page).to have_no_selector("subscribe")
      end
    end
  end

end
