require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe "uniqueness" do
    subject { Authorization.new(uid: "435304", provider: "something") }
    it { should validate_uniqueness_of(:provider).scoped_to(:uid) }
  end
end
