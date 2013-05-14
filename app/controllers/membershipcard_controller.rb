class MembershipcardController < ApplicationController

  permit "admin or (manager of :organization)"
  
  # GET /show
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        pdf = MembershipCard.new(@person)
        send_data pdf.render, :filename => "membershipcard.pdf", :type => "application/pdf"
      end
      format.xml  { render :xml => @person }
    end
  end

end
