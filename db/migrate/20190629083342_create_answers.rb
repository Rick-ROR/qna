class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :body, null: false
      t.boolean :correct, default: false

      t.timestamps
    end

    change_column_null(:questions, :title, false)
    change_column_null(:questions, :body, false)
  end
end
