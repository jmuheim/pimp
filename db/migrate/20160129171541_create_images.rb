class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :object
      t.references :document

      t.timestamps null: false
    end
  end
end
