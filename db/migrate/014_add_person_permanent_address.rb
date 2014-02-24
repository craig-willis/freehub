class AddPersonPermanentAddress < ActiveRecord::Migration
  def self.up
    add_column :people, :alternate_email, :string
    add_column :people, :permanent_street1, :string
    add_column :people, :permanent_street2, :string
    add_column :people, :permanent_city, :string
    add_column :people, :permanent_state, :string
    add_column :people, :permanent_postal_code, :string
    add_column :people, :permanent_country, :string
    add_column :people, :permanent_phone, :string
    add_column :people, :contact_name, :string
    add_column :people, :contact_phone, :string
    add_column :people, :contact_relation, :string
  end

  def self.down
    remove_column :people, :alternate_email
    remove_column :people, :permanent_street1
    remove_column :people, :permanent_street2
    remove_column :people, :permanent_city
    remove_column :people, :permanent_state
    remove_column :people, :permanent_postal_code
    remove_column :people, :permanent_country
    remove_column :people, :permanent_phone
    remove_column :people, :contact_name
    remove_column :people, :contact_phone
    remove_column :people, :contact_relation
  end
end


