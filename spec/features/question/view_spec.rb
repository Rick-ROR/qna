require 'rails_helper'

feature 'User can see a list of questions', %q(
  I would like to see a list of questions,
  even if I am not registered
) do

  scenario 'User sees a list of questions' do
    questions = create_list(:question, 3)
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end


end
