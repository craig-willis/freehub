# This controller handles the login/logout function of the site.  
class StaffsController < ApplicationController


  def new
    session[:return_to] = request.fullpath
  end

  def create
    @staff = Person.staff_login(params[:email], params[:password])
    if (!@staff.empty?)
      session[:staff_user] = @staff
      redirect_to(session[:stored_location])
      flash[:notice] = "Staff login accepted"
    else
      flash[:notice] = "Staff login failed"
      render :action => 'new'
    end
  end
end
