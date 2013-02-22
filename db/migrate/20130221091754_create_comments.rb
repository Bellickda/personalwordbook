class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :accounts_id #外部キー
      t.string :comment
      t.string :name

      t.timestamps
    end
  end
end
