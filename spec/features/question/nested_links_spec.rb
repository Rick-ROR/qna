require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
  I'd like to be able to edit links
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  !given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:rnd_url) {'https://bugzilla.mozilla.org/show_bug.cgi?id=1362154'}

  background do
    sign_in(user)
  end

  scenario 'User adding links when asks question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within all(".nested_link").first do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Add more link'

    within all(".nested_link").last do
      fill_in 'Link name', with: 'one link'
      fill_in 'Url', with: rnd_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'one link', href: rnd_url
  end

  scenario 'User editing link when edit question', js: true do
    create(:link, linkable: question)
    visit question_path(question)

    within('.question_box') do
      click_on 'Edit'

      within all(".nested_link").first do
        fill_in 'Link name', with: 'Duck'
        fill_in 'Url', with: 'https://duckduckgo.com/'
      end

      click_on 'Save'

      expect(page).to have_link 'Duck', href: 'https://duckduckgo.com/'
    end
  end

  scenario 'User deleting link when edit question', js: true do
    link = create(:link, linkable: question)
    visit question_path(question)

    within('.question_box') do
      click_on 'Edit'

      check 'Del link'

      click_on 'Save'

      expect(page).to_not have_link link.name
    end
  end

  scenario 'User adding links when edit question', js: true do
    visit question_path(question)

    within('.question_box') do
      click_on 'Edit'

      within all(".nested_link").first do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Add more link'

      within all(".nested_link").last do
        fill_in 'Link name', with: 'one link'
        fill_in 'Url', with: rnd_url
      end

      click_on 'Save'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'one link', href: rnd_url
    end
  end
end
