class ChangeStateTypeInVotes < ActiveRecord::Migration[5.2]
  def change
    change_column(:votes, :state, :integer, using: 'state::integer')
  end
end
