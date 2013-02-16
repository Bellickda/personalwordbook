class CreateAndroids < ActiveRecord::Migration
  def change
    create_table :androids do |t|
      t.integer :userid
      t.integer :random

      t.timestamps
    end
  end
end
