require 'rails_helper'

RSpec.describe Question, type: :model do
  it{ should belong_to(:author) }
  it{ should have_many(:answers).dependent(:destroy)}
  it{ should have_many(:links).dependent(:destroy)}
  it{ should have_one(:reward).dependent(:destroy)}

  it{ should validate_presence_of :title}
  it{ should validate_presence_of :body}

  it{ should accept_nested_attributes_for :links }
  it{ should accept_nested_attributes_for :reward }

  it "has the module Authorable" do
    expect(described_class.include?(Authorable)).to eq true
  end

  it "has the module Linkable" do
    expect(described_class.include?(Linkable)).to eq true
  end

  it "has the module Votable" do
    expect(described_class.include?(Votable)).to eq true
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
