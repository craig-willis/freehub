class AddVisitShop < ActiveRecord::Migration
  def self.up
    add_column :visits, :shop, :tinyint
  end

  def self.down
    remove_column :visits, :shop
  end
end
