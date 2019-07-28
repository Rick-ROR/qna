class AddBestToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions,  :best, foreign_key: { to_table: :answers }
  end
end
