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

  it "should have many :links" do
    expect(WithLinkable.reflect_on_association(:links).macro).to eq(:has_many)
  end
end
