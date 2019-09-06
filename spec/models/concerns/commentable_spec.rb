require 'rails_helper'

RSpec.describe 'Commentable' do
  with_model :WithCommentable do
    table do |t|
    end

    model do
      include Commentable
    end
  end

  let(:user) { create(:user) }
  let!(:comment) { build_stubbed(:comment) }

  it "should have many votes" do
    some = WithCommentable.create!
    expect(some.comments.create!(comment.attributes.merge({ author: user}) ).commentable).to eq some
  end

end
