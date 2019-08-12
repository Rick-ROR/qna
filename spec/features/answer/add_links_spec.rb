require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:gist_url) {'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}
  given(:rnd_url) {'https://bugzilla.mozilla.org/show_bug.cgi?id=1362154'}

  scenario 'User adding links when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within 'div.new-answer' do

      fill_in 'Body', with: 'My answer'

      within '#link-0' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Add more link'

      within '#link-1' do
        fill_in 'Link name', with: 'one link'
        fill_in 'Url', with: rnd_url
      end

      click_on 'Reply'
    end

    within '.question_answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'one link', href: rnd_url
    end
  end

end
