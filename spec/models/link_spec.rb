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

  describe '#gist?' do
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/Rick-ROR/1fc3a1e822599d0f79627b89938b3916') }
    let!(:link) { build(:link, url: 'https://www.w3schools.com/') }

    it { expect(gist_link).to be_gist }
    it { expect(link).to_not be_gist }
  end

  describe '#gist' do
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/Rick-ROR/1fc3a1e822599d0f79627b89938b3916') }

    it { expect(gist_link.gist).to be_a_kind_of Array }
    it { expect(gist_link.gist.first).to include(name: 'Built in matchers - RSpec Expectations.txt', content: 'hash usage') }
  end
end
