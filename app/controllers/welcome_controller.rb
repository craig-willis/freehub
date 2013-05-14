class WelcomeController < ApplicationController

  permit "admin or (manager of :organization)"
  
  # GET /welcome
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

end
