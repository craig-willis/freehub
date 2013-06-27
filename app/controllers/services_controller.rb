require 'net/smtp'

class ServicesController < ApplicationController

  permit "admin or (manager of :organization)"

  before_filter :store_location
  before_filter :requires_staff_password, :only => [:edit, :new]

  # GET /services
  # GET /services.xml
  def index
    @services = @person.services.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/new
  # GET /services/new.xml
  def new
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.xml
  def create
    @service = Service.new(params[:service])
    @service.note = Note.new(params[:note]) if params[:note]
    @service.person = @person


    respond_to do |format|
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to person_path(:id => @person) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end

    from = "cawillis@gmail.com"
    if (!@person.email.empty?)

      to = @person.email

      content = <<EOF
From: #{from}
To: #{to}
subject: Your Bike Project Membership
Date: #{Time.now.rfc2822}

Welcome to The Bike Project of Urbana-Champaign! This email confirms your membership to The Bike Project of Urbana-Champaign. Your membership is

   Type: #{@person.membership.service_type.name}
   Start Date: #{@person.membership.start_date}
   Expire Date: #{@person.membership.end_date}

Through membership, the Bike Project co-op offers a space, tools, and community to repair bikes, share knowledge, hold classes, and advocate for bikes in CU.  We offer two bike shop locations. Your membership is valid at both locations.

Downtown Urbana Bike Project
202 S. Broadway Ave., Urbana, IL 61801

Campus Bike Shop
608 E. Pennsylvania Ave., Champaign, IL 61820

More information is available at our website: http://thebikeproject.org

See our online calendar: http://thebikeproject.org/calendar

See more membership information, or even renew online at: http://thebikeproject.org/membership.html

For info on getting access to the shop, see: http://thebikeproject.org/orientation.html

As part of your membership, you will be added to the bikecoop-announce@lists.chambana.net mailing list!  This is a low-traffic, moderated list to make announcements related to the Bike Project and the local bicycle community.  You will receive a separate email about the listerv.

----                                                                                                                                                                                                                                                202 S. Broadway, Urbana, Illinois 61801
Email: thebikeproject@gmail.com
Phone: (217) 469-5126
www.thebikeproject.org
EOF

  print content
      Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.start('gmail.com', from, 'm3t4m4g1c', :login)
      smtp.send_message(content, from, to)
  end

  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
    @service = Service.find(params[:id])
    @service.note = Note.new(params[:note]) if params[:note]

    respond_to do |format|
      if @service.update_attributes(params[:service])
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to service_path(:id => @service) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id])
    @service.destroy
    flash[:notice] = 'Service was successfully removed.'

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml  { head :ok }
    end
  end
end
