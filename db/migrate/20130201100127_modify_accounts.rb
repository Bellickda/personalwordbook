# coding: utf-8
class ModifyAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :category, :string #カテゴリ
    add_column :accounts, :priority, :integer #重要度
    add_column :accounts, :url, :string #URL
    add_column :accounts, :image, :string #画像
    add_column :accounts, :groupid, :integer #グループid
    remove_column :accounts, :inputdate
  end

  def down
    remove_column :accounts, :category
    remove_column :accounts, :priority
    remove_column :accounts, :url
    remove_column :accounts, :image
    remove_column :accounts, :groupid
    add_column :accounts, :inputdate, :datetime
  end
end
