class SessionsController < ApplicationController
  before_filter :authenticate, :only=>:destroy    
  before_filter :check_expiration, :only=>:create 
  def new
    if !cookies.signed[:remember_token].nil?
      redirect_to current_user  
    end
  end
  
  def create
    user=CrmMemberList.authenticate(params[:session][:mbr_id],params[:session][:password])
    session[:password] = params[:session][:password]
    if user.nil?
      # Create an error message and re-render the signin form.
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      #if Time.now>user.exp_date && Time.now <=user.exp_date+2.months
        #user can login renew and change rebeat
      #elsif Time.now>=user.exp_date+2.months
      if Time.now>=user.exp_date+2.months  
        user.update_attributes(:status_level=>-1, :password=>session[:password])
        redirect_to signin_path, :notice => "Sorry, your membership has expiried."
      elsif
        if params[:remember]=="1"
          cookies.signed[:remember_token] = {:value=>[user.coy_id, user.mbr_id], :expires=>15.days.from_now}          
        else
          cookies.signed[:remember_token] = {:value=>[user.coy_id, user.mbr_id]}          
        end
        sign_in user    
        redirect_to user  
      end    
    end
  end

  def destroy     
    sign_out
    redirect_to root_path 
  end

end
