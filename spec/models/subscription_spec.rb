require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it{ should belong_to(:user) }
  it{ should belong_to(:question) }

  describe "uniqueness" do
    subject { build(:subscription) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  end
end
