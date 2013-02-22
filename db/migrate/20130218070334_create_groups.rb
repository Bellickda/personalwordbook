class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :concept
      t.text :members

      t.timestamps
    end
  end
end
