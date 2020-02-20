require 'sphinx_helper'

feature 'user can search on the site', %q{
  As an user
  I'd like to be able to search on site materials
} do
  given!(:question) { create(:question) }

  scenario 'search anything', js: true, sphinx: true do
    visit root_path
    page.save_and_open_screenshot
    expect(page).to have_content question.title

    ThinkingSphinx::Test.run do

      fill_in 'query', with: ''
      click_on 'go'

      page.save_and_open_screenshot
      expect(page).to have_content question.title
    end
  end

  scenario 'search title', js: true, sphinx: true do
    visit root_path
    expect(page).to have_content question.title

    ThinkingSphinx::Test.run do

      fill_in 'query', with: "title"
      click_on 'go'

      expect(page).to have_content question.title
    end
  end

end
