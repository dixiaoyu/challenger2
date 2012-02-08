class CrmMemberTransaction < ActiveRecord::Base
  set_table_name 'crm_member_transaction'
  belongs_to :crm_member_list,:foreign_key => :mbr_id
  
  default_scope :order => 'crm_member_transaction.trans_date DESC'
  
  def self.find_through_trans_type(trans_type)
    where(:trans_type => trans_type)
  end  
  
  def self.filter_through_date(from,till,type)    
    where("trans_date>=? and trans_date<=? and trans_type=? ",from,till,type)
  end
end
