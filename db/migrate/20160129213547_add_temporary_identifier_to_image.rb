class AddTemporaryIdentifierToImage < ActiveRecord::Migration
  def change
    add_column :images, :identifier, :string
  end
end
