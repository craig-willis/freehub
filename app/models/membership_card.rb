class MembershipCard < Prawn::Document

  def initialize(person)
    super(:page_size   => 'C8',
          :page_layout => :landscape,
          :margin => [15,15,15,15])
    logopath =  "#{Rails.root}/app/assets/images/tbp-logo.png"
    image logopath, :width => 100
    move_down 15
    text "<font size='10'>Name: #{person.full_name}\n" +
             "Type: #{person.membership.service_type.name}\n" +
             "Membership Expires: #{person.membership.end_date}</font>\n", :inline_format => true
    move_down 20
    stroke_horizontal_rule
    move_down 5
    text "<font size='5'>" +
             "202 S. Broadway, Room 24, Urbana, Illinois 61801\n" +
             "thebikeproject@gmail.com, (217) 469-5126\n" +
             "www.thebikeproject.org" +
             "</font>", :align => :center, :inline_format => true
  end
end
