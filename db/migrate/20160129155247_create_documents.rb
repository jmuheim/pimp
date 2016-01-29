class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.text :description
      t.text :content
      t.integer :user_id
      t.integer :lock_version, default: 0

      t.timestamps null: false
    end
  end
end
