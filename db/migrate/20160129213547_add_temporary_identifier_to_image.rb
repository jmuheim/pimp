class AddTemporaryIdentifierToImage < ActiveRecord::Migration
  def change
    add_column :images, :temporary_identifier, :text
  end
end
