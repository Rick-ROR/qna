require 'rails_helper'

RSpec.describe Answer, type: :model do
  it{ should belong_to(:question) }
  it{ should belong_to(:author) }

  it{ should validate_presence_of :body }

  it "test default scope" do
    answers = create_list(:answer, 4, question: create(:question))
    answers.last.make_best
    expect(Answer.all.to_sql).to eq Answer.unscoped.all.order(best:  :desc, created_at: :desc).to_sql
  end

  it "test scope get_best" do
    answers = create_list(:answer, 4)
    answers.last.update(best: true)
    expect(Answer.all.get_best.to_sql).to eq Answer.all.where(best: true).to_sql
  end

  describe '#make_best' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 4, question: question) }

    it "set best to 'true' for this answer" do
      expect { answers.first.make_best }.to change { answers.first.reload.best }.from(false).to(true)
    end

    it "set best to 'true' for another answer and set best to 'false' for old best answer" do
      answer_one = answers.first
      answer_two = answers.last
      expect { answer_one.make_best }.to change { answer_one.reload.best }.from(false).to(true)
      expect { answer_two.make_best }.to change { answer_two.reload.best }.from(false).to(true)
      .and  change { answer_one.reload.best }.from(true).to(false)
    end
  end
end
