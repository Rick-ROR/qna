require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :author }

  it do
    should validate_inclusion_of(:state).
      in_array([true, false])
  end

  describe "associations" do
    subject { FactoryBot.create(:vote) }
    it { should validate_uniqueness_of(:author_id).scoped_to([:votable_type, :votable_id]).case_insensitive }
  end

  describe '#twice?' do
    let!(:vote) { create(:vote) }

    it do
      expect(vote.twice?(vote.state)).to eq true
      vote.state = nil
      expect(vote.twice?(true)).to eq false
    end
  end

  describe '#voting(state)' do

    it "saved new vote" do
      vote = Vote.new(author: create(:user), votable: create(:question))
      expect { vote.voting(true) }.to change { Vote.count }.from(0).to(1)
      expect(Vote.all.first.state).to eq true
    end

    it "changes the vote to opposite" do
      vote = Vote.create(author: create(:user), votable: create(:question), state: false)
      expect { vote.voting(true) }.to change { vote.reload.state }.from(false).to(true)
    end

    it "deletes a vote if same has already been" do
      vote = Vote.create(author: create(:user), votable: create(:question), state: true)
      expect { vote.voting(true) }.to change { Vote.count }.from(1).to(0)
    end
  end
end
