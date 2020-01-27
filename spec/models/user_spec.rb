require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:author_questions) }
  it { should have_many(:author_answers) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  describe '#author_of?' do
    let(:author) { create(:user) }

    it 'returns true if the user is the author of the question' do
      question = create(:question, author: author)
      expect(author).to be_an_author_of(question)
    end

    it 'returns false if the user is not the author of the question' do
      question = create(:question)
      expect(author).not_to be_an_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '31414')}
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:call).with(auth)
      User.find_for_oauth(auth)
    end
  end

end
