require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validate url' do
    let(:question) { create(:question) }
    let!(:valid) { build(:link, url: 'https://www.w3schools.com/cssref/css_selectors.asp', linkable: question) }
    let!(:invalid) { build(:link, url: 'cssref/css_selectors', linkable: question) }

    it { expect(valid).to be_valid }
    it { expect(invalid).to be_invalid }

    it do
      invalid.validate
      expect(invalid.errors[:url]).to include('Ooops! URL has an invalid format.')
    end
  end
end
