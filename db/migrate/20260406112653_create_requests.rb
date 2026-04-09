class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.references :requester, null: false,  foreign_key: { to_table: :users }
      t.references :requestee, null: false, foreign_key: { to_table: :users }
      t.references :listing, null: false, foreign_key: { to_table: :listings }
      t.references :offered_listing, null: false, foreign_key: { to_table: :listings }
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
