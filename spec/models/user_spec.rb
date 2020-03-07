require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:author_questions) }
  it { should have_many(:author_answers) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :password }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }

  describe 'validate email' do
    let!(:valid) { build(:user, email: 'Silence@example.edu') }
    let!(:invalid) { build(:user, email: '@kkk@example.edu') }

    it { expect(valid).to be_valid }
    it { expect(invalid).to be_invalid }
  end

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:question) { create(:question) }
    let(:question_author) { create(:question, author: author) }

    it 'returns true if the user is the author of the question' do
      expect(author).to be_an_author_of(question_author)
    end

    it 'returns false if the user is not the author of the question' do
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

  describe '#email_format_valid?' do
    let(:user) { build(:user) }
    let(:user_invalid) { build(:user, email: '@kkk@example.edu') }

    it 'returns true if email is valid' do
      expect(user.email_format_valid?).to be true
    end

    it 'returns false if email is invalid' do
      expect(user_invalid.email_format_valid?).to be false
    end

  end

  describe '#get_sub_on_question' do
    let!(:subscription) { create(:subscription) }
    let!(:subscriber) { subscription.user }
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }

    it 'returns subscription if exists' do
      expect(subscriber.get_sub_on_question(subscription.question)).to eq subscription
    end

    it 'returns nil if not exists' do
      expect(user.get_sub_on_question(question)).to be nil
    end

  end

  describe '#email_short' do
    let!(:user) { create(:user) }

    it 'returns mail username only' do
      expect(user.email_short).to eq "@" + user.email.split('@').first
    end

  end

end
