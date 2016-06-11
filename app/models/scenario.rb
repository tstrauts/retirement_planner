class Scenario < ActiveRecord::Base
  validates :name, :presence => true
  validates :description, :presence => true, length: { maximum: 100 }
  validates :current_age, :presence => true, numericality: { only_integer: true, :greater_than => 0, :less_than_or_equal_to => 110 }
  validates :life_expectancy, :presence => true, numericality: { only_integer: true, :greater_than => 1, :less_than_or_equal_to => 110, :greater_than => :current_age }
  validates :retplan_assets, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :retplan_savings, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :tradira_assets, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :tradira_savings, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :rothira_assets, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :rothira_savings, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :taxaccount_assets, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :taxaccount_savings, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0}
  validates :usstocks_alloc_pre, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :usstocks_ret_pre, :presence => true, numericality: { only_integer: false, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20}
  validates :intlstocks_alloc_pre, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :intlstocks_ret_pre, :presence => true, numericality: { only_integer: false, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20}
  validates :bonds_alloc_pre, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :bonds_ret_pre, :presence => true, numericality: { only_integer: false, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20}
  validates :usstocks_alloc_ret, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :usstocks_ret_ret, :presence => true, numericality: { only_integer: false, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20}
  validates :intlstocks_alloc_ret, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :intlstocks_ret_ret, :presence => true, numericality: { only_integer: false, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20}
  validates :bonds_alloc_ret, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :bonds_ret_ret, :presence => true, numericality: { only_integer: false, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20}
  validates :socialsecurity_income, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 36000 }
  validates :socialsecurity_startage, :presence => true, numericality: { only_integer: true, :greater_than => 61, :less_than_or_equal_to => 70 }
  validates :pension_income, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 500000 }
  validates :pension_startage, :presence => true, numericality: { only_integer: true, :greater_than => 20, :less_than_or_equal_to => 80 }
  validates :other_income, :presence => true, numericality: { only_integer: true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 500000 }
  validates :other_startage, :presence => true, numericality: { only_integer: true, :greater_than => 0, :less_than_or_equal_to => 110 }
  validates :education_expense, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1000000, :allow_blank => true }
  validates :education_startage, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 109, :allow_blank => true }
  validates :education_endage, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 110, :allow_blank => true }
  validates :retirement_income, :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10000000 }
  validates :retirement_startage, :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than => :life_expectancy}
  validates :inflation_rate, :presence => true
  validates :ret_taxrate, :presence => true

  validate :sum_equals_100


  belongs_to :user

  def sum_equals_100
    if usstocks_alloc_pre + intlstocks_alloc_pre + bonds_alloc_pre != 100
      errors.add(:base, 'Pre-retirement allocation must sum to 100')
    end
    if usstocks_alloc_ret + intlstocks_alloc_ret + bonds_alloc_ret != 100
      errors.add(:base, 'Retirement allocation must sum to 100')
    end
  end
end
