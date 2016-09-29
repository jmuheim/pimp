class AddIdentifierToImage < ActiveRecord::Migration
  def change
    add_column :images, :identifier, :string # Although the identifier always is an integer, it can't be type :number because it exceeds its max. limit (11)
  end
end
