class AddPersonPassword < ActiveRecord::Migration
  def self.up
    add_column :people, :hashed_password, :string
  end

  def self.down
    remove_column :people, :hashed_password
  end
end
