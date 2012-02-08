class CrmMemberListsController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  before_filter :deny_operation, :only=>[:show, :detail, :change]
  
  def new
    @member = CrmMemberList.new
    @title = "Signup Page"
  end
  
  def create
    @member = CrmMemberList.new(params[:crm_member_list])
    @member.status_level=1
    if @member.save
      cookies.signed[:remember_token] = {:value=>[@member.coy_id, @member.mbr_id]} 
      sign_in @member
      #sign_in @member
      #flash[:sucess]="Welcome to Challenger!"
      redirect_to @member
    else 
      @title = "Signup Page"
      render 'new'
    end
  end  
  
  def show
    @member = CrmMemberList.find(params[:id])    
    @title = "Home Page"    
  end
  
  def detail
    @member = CrmMemberList.find(params[:id])
  end
  
  def change
    @member = CrmMemberList.find(params[:id])
  end
  
  def update
    @member = CrmMemberList.find(params[:id])
    if params[:crm_member_list][:email_addr].empty? 
      redirect_to edit_path(params[:id]), notice: 'Please fill the field with *.'
    else  
      key=params[:mbr_title]
      if key=="1"
        title="MISS"
      elsif key == "2"
        title="MR"
      elsif key=="3"
        title="MRS"
      else
        title="MS"      
      end
      year=params[:birth]['user(1i)']
      month=params[:birth]['user(2i)']
      day=params[:birth]['user(3i)']
      d=Date.new(year.to_i, month.to_i, day.to_i).to_s

      @member.update_attributes(:email_addr => params[:crm_member_list][:email_addr],
                                :mbr_title => title,
                                :birth_date =>d,
                                #:birth_date => params[:crm_member_list][:birth_date],                                
                                :mbr_addr=>"0-PRIMARY",
                                :delv_addr=>"2-DELEVERY",                                 
                                :mobile_phone => params[:crm_member_list][:contact_num],
                                :password => session[:password])
      redirect_to detail_path(params[:id]), notice: 'Profile was successfully updated.'
    end    
  end

  def statuscheck
    @member = CrmMemberList.find(params[:id])
  end

  
  
  def renew
    @member = CrmMemberList.find(params[:id])
    old_expiry_date = @member.exp_date
    if params[:type]=="1"
      if old_expiry_date < Time.now
        @member.update_attributes(:last_renewal => Time.now, :exp_date => 2.years.from_now, :status_level=>1, :password => "12345678") 
      else
        new_expiry_date = old_expiry_date+2.years
        @member.update_attributes(:last_renewal => Time.now, :exp_date => new_expiry_date, :status_level=>1, :password => "12345678")
      end
      max_id=CrmMemberTransaction.maximum("id") 
      max_line=CrmMemberTransaction.maximum("line_num")
      id = max_id+1
      line_num = max_line+1
      @transaction=CrmMemberTransaction.new(:id=>id, :coy_id=>"CTL", :mbr_id=>current_user.mbr_id,:line_num=>line_num,:trans_date=>Time.now,:item_id=>"8887815245251",:item_desc=>"Challenger Membership Renewal", :item_qty=>1,:trans_points=>"2000")
      @transaction.save 
    else
      redirect_to status_path(params[:id]), notice: 'Please choose renewal type.' 
    end         
  end
  
end

