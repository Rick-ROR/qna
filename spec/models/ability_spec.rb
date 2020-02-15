require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should	be_able_to	:read, Question }
    it { should	be_able_to	:read, Answer }
    it { should	be_able_to	:read, Comment }

    it { should_not	be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true}

    it { should	be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user}
    let(:other_user) {create :user}
    let(:user_question) { build(:question, :with_file, author: user) }
    let(:other_user_question) { build(:question, :with_file, author: other_user) }
    let(:user_answer) { build(:answer, :with_file, author: user) }
    let(:other_user_answer) { build(:answer, :with_file, author: other_user) }
    let(:user_comment) { build(:comment, author: user, commentable: other_user_question) }
    let(:other_user_comment) { build(:comment, author: other_user, commentable: other_user_question) }

    it { should_not	be_able_to :manage, :all }
    it { should	be_able_to	:read, :all }

    # CREATE
    it { should	be_able_to	:create, Question }
    it { should	be_able_to	:create, Answer }
    it { should	be_able_to	:create, Comment }

    # UPDATE

    it { should be_able_to :update, user_question }
    it { should_not be_able_to :update, other_user_question }

    it { should be_able_to :update, user_answer }
    it { should_not be_able_to :update, other_user_answer }

    # DESTROY

    it { should be_able_to :destroy, user_question }
    it { should_not be_able_to :destroy, other_user_question }

    it { should be_able_to :destroy, user_answer }
    it { should_not be_able_to :destroy, other_user_answer }

    it { should be_able_to :destroy, user_question.files.first }
    it { should_not be_able_to :destroy, other_user_question.files.first }

    it { should be_able_to :destroy, user_answer.files.first }
    it { should_not be_able_to :destroy, other_user_answer.files.first }

    # VOTE

    it { should be_able_to :vote, other_user_question }
    it { should_not be_able_to :vote, user_question }

    it { should be_able_to :vote, other_user_answer }
    it { should_not be_able_to :vote, user_answer }

    # BEST

    it { should be_able_to :best, create(:answer, question: user_question) }
    it { should_not be_able_to :best, create(:answer, question: other_user_question) }


    # REWARD

    it { should be_able_to :read, Reward }

    # SUBSCRIBE

    it { should be_able_to :subscribe, Subscription }

  end
end


