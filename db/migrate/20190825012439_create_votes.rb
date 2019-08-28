class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.boolean :state
      t.belongs_to :votable, polymorphic: true
      t.belongs_to :author, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
