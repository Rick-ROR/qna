require 'rails_helper'

feature 'User can subscribe on question', %q{
  To receive notifications about new answers to a question
  As an authenticated user
  I'd like to be able to subscribe to the question
  I'd like to be able to unsubscribe to the question
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
        expect(page).to have_field("subscribe")

        check("subscribe")
        expect(page.find("input#subscribe")).to be_checked
      end
    end

    scenario 'User unsubscribe on question', js: true do
      within('.question_box') do
        expect(page).to have_field("subscribe")
        check("subscribe")
        expect(page.find("input#subscribe")).to be_checked

        visit current_path
        expect(page.find("input#subscribe")).to be_checked

        uncheck("subscribe")
        expect(page.find("input#subscribe")).to_not be_checked
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
