require 'rails_helper'

RSpec.describe 'Votable' do
  with_model :WithVotable do
    table do |t|
    end

    model do
      include Votable
    end
  end

  let(:user) { create(:user) }
  let!(:vote) { build_stubbed(:vote) }

  it "should have many votes" do
    some = WithVotable.create!
    expect(some.votes.create!(vote.attributes.merge({ author: user}) ).votable).to eq some
  end

  it "#rating" do
    some = WithVotable.create!
    expect(some.rating).to eq 0

    create_list(:vote, 3, votable: some)
    create(:vote, votable: some, state: -1)
    expect(some.rating).to eq 2
  end

end
