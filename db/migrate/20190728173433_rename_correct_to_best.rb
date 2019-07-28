class RenameCorrectToBest < ActiveRecord::Migration[5.2]
  def change
    rename_column :answers, :correct, :best
  end
end
