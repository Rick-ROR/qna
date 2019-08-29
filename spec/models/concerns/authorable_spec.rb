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

  it "should have belongs_to :author" do
    expect(WithAuthorable.reflect_on_association(:author).macro).to eq(:belongs_to)
  end
end
