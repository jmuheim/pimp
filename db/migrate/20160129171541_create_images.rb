class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :object
      t.integer :document_id, null: false

      t.timestamps null: false
    end
  end
end
