class ServiceType
  attr_reader :id, :name, :description

  def initialize(id, name, description)
    @id, @name, @description = id, name, description
  end

  #Regular ($40 per year/person)
  #Family ($65 per year/family)
  #Student ($25 per year/person)
  #With bike purchase (1 year membership included)
  #Work equity

  TYPES = [
            ServiceType.new('MEMBERSHIP', "Regular membership ($40/year)", "Membership for this shop."),
            ServiceType.new('FAMILY', "Family membership ($65/year)", "Membership for this shop."),
            ServiceType.new('STUDENT', "Student membership ($25/year)", "Membership for this shop."),
            ServiceType.new('WBP', "Membership with bike purchase", "Membership for this shop."),
            ServiceType.new('WORKEQUITY', "Work equity membership", "Membership for this shop.")
          ]

  def self.[](id)
    TYPES.select{|type| type.id == id.to_s.upcase }.first
  end

  def self.find_all
    TYPES
  end

end
