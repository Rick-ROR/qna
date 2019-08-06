class RemoveBestAnswerToQuestions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :questions,  :best, foreign_key: { to_table: :answers }
  end
end
