class AddPersonAcceptWaiver < ActiveRecord::Migration
  def self.up
    add_column :people, :accept_waiver, :tinyint
  end

  def self.down
    remove_column :people, :accept_waiver
  end
end
