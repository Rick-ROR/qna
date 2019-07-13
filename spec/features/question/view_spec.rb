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


feature 'User can view the question and answers to it.', %q(
  I would like to see questions and a list of answers to it,
  even if I am not registered
) do

  given(:question) { create(:question) }

  scenario 'User can view the question and answers to it' do
    answers = create_list(:answer, 4, question: question)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
