require 'rails_helper'

RSpec.describe 'Linkable' do
  with_model :WithLinkable do
    table do |t|
    end

    model do
      include Linkable
    end
  end

  let(:link) { build(:link) }

  it "has the module" do
    expect(WithLinkable.include?(Linkable)).to eq true
  end

  it "can be accessed as a constant" do
    expect(WithLinkable).to be
  end

  it "should have many links" do
    some = WithLinkable.create!
    expect(some.links.create!(link.attributes).linkable).to eq some
  end
end
