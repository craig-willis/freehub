class MembershipCard < Prawn::Document

  def initialize(person)
    super(:page_size   => 'C8',
          :page_layout => :landscape,
          :margin => [15,15,15,15])
    logopath =  "#{Rails.root}/app/assets/images/tbp-logo.png"
    image logopath, :width => 30
    text "The Bike Project of Urbana-Champaign"
    text "Name: #{person.full_name}"
    text "Type: #{person.membership.service_type.name}"
    text "Started: #{person.membership.start_date}"
    text "Expires: #{person.membership.end_date}"
  end
end