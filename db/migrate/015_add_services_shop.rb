class AddServicesShop < ActiveRecord::Migration
  def self.up
    add_column :services, :shop, :tinyint
    add_column :services, :send_email, :tinyint
  end

  def self.down
    remove_column :services, :shop
    remove_column :services, :send_email
  end
end
