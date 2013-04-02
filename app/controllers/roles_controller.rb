class RolesController < ApplicationController

  permit "admin or (manager of :organization)"

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /role/
  # GET /role/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end


  # GET /role/edit
  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # POST /role
  # POST /role.xml
  def update

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html {
          redirect_to edit_person_path(:organization_key => @organization.key, :id => @person)
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end
end
