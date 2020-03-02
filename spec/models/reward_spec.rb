require 'rails_helper'

RSpec.describe Reward, type: :model do
  it{ should belong_to(:question).touch(true) }
  it{ should belong_to(:answer).optional }

  it { should validate_presence_of :title }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it 'validate attached type' do
    expect(build(:reward, :with_image)).to be_valid
    expect(build(:reward, image: fixture_file_upload(file_fixture("Ellesmere.rom")) )).to_not be_valid
  end

end
