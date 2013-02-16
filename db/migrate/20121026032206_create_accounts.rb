# coding: utf-8
class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id #外部キー
      t.string :title #URLのtitle
      t.text :content #URLのdescription
      t.datetime :inputdate

      t.timestamps
    end
  end
end
