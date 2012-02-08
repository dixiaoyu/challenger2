require 'digest/MD5'
class CrmMemberList < ActiveRecord::Base
  set_table_name 'crm_member_list'
  #set_primary_keys :coy_id, :mbr_id
  
  attr_accessor :password, :password_confirmation
  
  attr_accessible :mbr_id, :password, :password_confirmation, :first_name, :last_name, :email_addr, :contact_num,
                  :points_accumulated, :points_reserved, :points_redeemed, :status_level, :mbr_title, :birth_date,
                  :nationality_id, :mbr_addr, :delv_addr, :send_info, :send_type, :last_renewal, :exp_date
  
  has_many :crm_member_transactions
  has_many :crm_redemption_reservations
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #add
  validates :mbr_id,  :presence => true,
                      :length   => { :within => 6..10 },                       
                      :uniqueness => { :case_sensitive => false }
  #add                     
  validates :email_addr, :presence => true,
                         :format   => { :with => email_regex }
  
  validates :first_name, :presence => true      
  #validates :last_name, :presence => true                          
                 
  validates :password, :confirmation => true,
                       :length       => { :within => 6..40 } 
  #add
                     
  before_save :encrypt_password    

  def has_password?(submitted_password)
    self.mbr_pwd == encrypt(submitted_password)
  end  
  
  def self.authenticate(mbr_id, submitted_password)
    member = find_by_mbr_id(mbr_id)
    return nil  if member.nil?
    return member if member.has_password?(submitted_password)
  end 
  
  def self.authenticate_with_salt(coy_id, mbr_id)
    user = find_by_mbr_id(mbr_id)
    (user && user.coy_id == coy_id) ? user : nil
  end 
  
  def self.updatepoints(mbr_id,accumulated,reserved)
    user = find_by_mbr_id(mbr_id)
    user.update_attributes(:points_accumulated => accumulated, :points_reserved => reserved)        
  end 
     
 
  
  private
  
    def encrypt_password
      self.mbr_pwd = encrypt(password)
    end    
    
    def encrypt(string)
      secure_hash(string)
    end     
    
    def secure_hash(string)
      Digest::MD5.hexdigest(string)
    end                  
end
