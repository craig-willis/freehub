class PeopleController < ApplicationController

  permit "admin or (manager of :organization)"

  before_filter :store_location
  before_filter :requires_staff_password, :only => :edit

  # GET /people/1
  # GET /people/1.xml
  def show
    session[:staff_user] = [];
    @person = Person.find(params[:id])
    @all_tags = @organization.tag_list

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])

  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    @person.organization = @organization

    if params[:person][:accept_waiver] != "0"
      respond_to do |format|
        if @person.save
          @person.services << Service.new(:service_type_id => 'MEMBERSHIP', :paid => true) if params[:membership]
          @person.services << Service.new(:service_type_id => 'EAB', :paid => true) if params[:eab]
          @person.visits << Visit.new if params[:visiting]

          flash[:notice] = 'New profile created.'
          format.html do
            if params[:visiting]
              redirect_to today_visits_path
            else
              redirect_to new_interests_path(:organization_key => @organization.key, :person_id => @person.id)
            end
          end
          format.xml  { render :xml => @person, :status => :created, :location => @person }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'You must accept the liability waiver to create an account.'
      render :new
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html {
          #redirect_to(person_path)
          redirect_to edit_interests_path(:organization_key => @organization.key, :person_id => @person.id)
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @interest = Interests.for_person(@person)[0]
    @interest.destroy
    @person.destroy

    flash[:notice] = 'Person was successfully removed.'

    respond_to do |format|
      format.html { redirect_to @organization }
      format.xml  { head :ok }
    end
  end

  def auto_complete_for_person_full_name
    @items = Person.for_organization(@organization).matching_name(params[:person][:full_name]).paginate(:size => 15)
    render :inline => "<%= auto_complete_result_with_add_person @items, 'full_name' %>"
  end
end
