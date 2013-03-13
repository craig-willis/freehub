class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.boolean :accounting
      t.references :person, :nil => false
    end

    execute "ALTER TABLE interests ADD CONSTRAINT fk_interests_person FOREIGN KEY (person_id) REFERENCES people(id)"
  end

  def self.down
    execute "ALTER TABLE interests DROP FOREIGN KEY fk_interests_person"

    drop_table :interests
  end
end
