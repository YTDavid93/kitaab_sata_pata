class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :book_name, null: false
      t.string :author_name, null: false
      t.string :genre, null: false
      t.string :description, null: false
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
