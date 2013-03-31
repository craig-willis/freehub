class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.boolean :BikeRepair, :nil => false, :default => false
      t.boolean :DataEntry, :nil => false, :default => false
      t.boolean :Sales, :nil => false, :default => false
      t.boolean :Publicity, :nil => false, :default => false
      t.boolean :Teaching, :nil => false, :default => false
      t.boolean :Office, :nil => false, :default => false
      t.boolean :Carpentry, :nil => false, :default => false
      t.boolean :Sewing, :nil => false, :default => false
      t.boolean :Vehicle, :nil => false, :default => false
      t.boolean :Grant, :nil => false, :default => false
      t.boolean :Accounting, :nil => false, :default => false
      t.boolean :Cleaning, :nil => false, :default => false
      t.boolean :EventPlanning, :nil => false, :default => false
      t.boolean :WorkingWithChildren, :nil => false, :default => false
      t.boolean :Website, :nil => false, :default => false
      t.boolean :Photography, :nil => false, :default => false
      t.boolean :Electrician, :nil => false, :default => false
      t.boolean :Legal, :nil => false, :default => false
      t.boolean :Newsletter, :nil => false, :default => false
      t.boolean :Whatever, :nil => false, :default => false
      t.timestamps
      t.references :created_by, :updated_by

      t.references :person, :nil => false
    end

    execute "ALTER TABLE interests ADD CONSTRAINT fk_interests_person FOREIGN KEY (person_id) REFERENCES people(id)"
  end

  def self.down
    execute "ALTER TABLE interests DROP FOREIGN KEY fk_interests_person"

    drop_table :interests
  end
end
