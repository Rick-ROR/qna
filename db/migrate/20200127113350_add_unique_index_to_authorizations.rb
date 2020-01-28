class AddUniqueIndexToAuthorizations < ActiveRecord::Migration[5.2]
  def change
    remove_index :authorizations, [:provider, :uid]
    add_index :authorizations, [:provider, :uid], :unique => true
  end
end
