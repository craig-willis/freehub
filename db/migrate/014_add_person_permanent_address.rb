class AddPersonPermanentAddress < ActiveRecord::Migration
  def self.up
    add_column :people, :permanent_address, :string
    add_column :people, :permanent_phone, :string
    add_column :people, :contact_name, :string
    add_column :people, :contact_phone, :string
    add_column :people, :contact_relation, :string
  end

  def self.down
    remove_column :people, :permanent_address
    remove_column :people, :permanent_phone
    remove_column :people, :contact_name
    remove_column :people, :contact_phone
    remove_column :people, :contact_relation
  end
end


