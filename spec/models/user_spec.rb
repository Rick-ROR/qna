require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:author_questions) }
  it { should have_many(:author_answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  describe 'author_of?' do
    let(:author) { create(:user) }

    context 'for the question' do
      it 'returns true if the user is the author' do
        question = create(:question, author: author)
        expect(author).to be_an_author_of(question)
      end

      it 'returns false if the user is not the author' do
        question = create(:question)
        expect(author).not_to be_an_author_of(question)
      end
    end

    context 'for the answer' do
      it 'returns true if the user is the author' do
        answer = create(:answer, author: author)
        expect(author).to be_an_author_of(answer)
      end

      it 'returns false if the user is not the author' do
        answer = create(:answer)
        expect(author).not_to be_an_author_of(answer)
      end
    end
  end

end
