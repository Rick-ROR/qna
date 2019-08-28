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

  it "has the module" do
    expect(WithVotable.include?(Votable)).to eq true
  end

  it "can be accessed as a constant" do
    expect(WithVotable).to be
  end

  it "should have many votes" do
    some = WithVotable.create!
    # #<Vote id: 1006, state: true, votable_type: nil, votable_id: nil, author_id: 1005, created_at: "2019-08-28 01:12:13", updated_at: "2019-08-28 01:12:13">
    # expect(some.votes.create!(vote.attributes).votable).to eq some
    # Validation failed: Author must exist
    expect(some.votes.create!(vote.attributes.merge({ author: user}) ).votable).to eq some
  end
  it "#rating" do
    some = WithVotable.create!
    expect(some.rating).to eq 0

    create_list(:vote, 3, votable: some)
    create(:vote, votable: some, state: false)
    expect(some.rating).to eq 2
  end

  it "#vote_path" do
    some = WithVotable.create!
    expect("vote_#{some.class.name.singularize.underscore}_path").to eq "vote_with_votable_path"
  end

  it "#by_user(user)" do
    some = WithVotable.create!
    some.votes.create!(vote.attributes.merge({ author: user}))
    expect(some.by_user(user).first.author).to eq user
  end


end
