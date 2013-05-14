class InterestsController < ApplicationController

  permit "admin or (manager of :organization)"

  # GET /interests
  # GET /interests.xml
  def index
    @interests = Interests.for_person(@person)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interests }
    end
  end

  # GET /interests/1
  # GET /interests/1.xml
  def show
    @interests = Interests.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interests }
    end
  end

  # GET /interests/new
  # GET /interests/new.xml
  def new
    @interests = Interests.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interests }
    end
  end

  # GET /interests/1/edit
  def edit
    @interests = Interests.for_person(@person)
  end

  # POST /interests
  # POST /interests.xml
  def create
    @interests = Interests.new(params[:interests])
    @interests.person = @person

    respond_to do |format|
      if @interests.save
        flash[:notice] = 'Interests saved.'
        format.html { redirect_to(welcome_path(:id => @person)) }
        format.xml  { render :xml => @interests, :status => :created, :location => @interests }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interests.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interests/1
  # PUT /interests/1.xml
  def update
    @interests = Interests.for_person(@person)[0]

    respond_to do |format|
      if @interests.update_attributes(params[:interests])
        flash[:notice] = 'Interests updated.'
        format.html { redirect_to(person_path(:id => @person)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interests.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interests/1
  # DELETE /interests/1.xml
  def destroy
    @interests = Interests.find(params[:id])
    @interests.destroy
    flash[:notice] = 'Interests was successfully removed.'

    respond_to do |format|
      format.html { redirect_to(interests_url) }
      format.xml  { head :ok }
    end
  end
end
