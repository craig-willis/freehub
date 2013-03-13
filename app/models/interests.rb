# == Schema Information
#
# Table name: interests
#
#  id                :integer(4)      not null, primary key
#  accounting        :boolean
#  authorizable_type :string(40)
#  authorizable_id   :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

# Defines named roles for users that may be applied to
# objects in a polymorphic fashion. For example, you could create a role
# "moderator" for an instance of a model (i.e., an object), a model class,
# or without any specification at all.
class Interests < ActiveRecord::Base
  belongs_to :person


  def initialize(params={})
    super
  end

  def self.for_person(person, options={})
    find_by_sql for_person_sql(person)
  end

  private

  def self.for_person_sql(person, options={})
    options[:select] ||= '*'
    options[:offset] ||= 0
    sql = "SELECT #{options[:select]} FROM interests
            WHERE (interests.person_id = #{person.id})"

    sql
  end
end
