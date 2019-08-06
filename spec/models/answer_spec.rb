require 'rails_helper'

RSpec.describe Answer, type: :model do
  it{ should belong_to(:question) }
  it{ should belong_to(:author) }

  it{ should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'testing scopes:' do
    let!(:answers) { create_list(:answer, 4, question: create(:question)) }
    let!(:answer) { answers.last }
    before { answer.update(best: true) }

    it "default scope" do
      expect(Answer.all.first).to eq answer
    end

    it "get_best" do
      expect(Answer.all.get_best).to eq [answer]
    end
  end

  describe '#make_best' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 4, question: question) }
    let!(:answer) { answers.first }

    it "set best to 'true' for this answer" do
      expect { answer.make_best }.to change { answer.reload.best }.from(false).to(true)
    end

    it "set best to 'true' for another answer and set best to 'false' for old best answer" do
      answer_two = answers.last
      answer.update(best: true)
      expect { answer_two.make_best }.to change { answer_two.reload.best }.from(false).to(true)
      .and  change { answer.reload.best }.from(true).to(false)
    end
  end
end
