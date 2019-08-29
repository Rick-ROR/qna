require 'rails_helper'

RSpec.describe 'Authorable' do

  with_model :WithAuthorable do
    table do |t|
      t.integer :author_id
    end

    model do
      include Authorable
    end
  end

  let(:user) { create(:user) }

  it "has the module" do
    expect(WithAuthorable.include?(Authorable)).to eq true
  end

  it "can be accessed as a constant" do
    expect(WithAuthorable).to be
  end

  it "should have belongs_to :author" do
    expect( WithAuthorable.create!( author: user ).author ).to eq user
  end
end
