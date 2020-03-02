require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable).touch(true) }

  it { should validate_presence_of :body }

  it "has the module Authorable" do
    expect(described_class.include?(Authorable)).to eq true
  end
end
