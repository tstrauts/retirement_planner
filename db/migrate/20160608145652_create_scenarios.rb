class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.integer :user_id
      t.text :description
      t.string :name
      t.integer :ret_taxrate
      t.float :inflation_rate
      t.boolean :retirement_inflation
      t.boolean :education_inflation
      t.integer :retirement_startage
      t.integer :retirement_income
      t.integer :education_endage
      t.integer :education_startage
      t.integer :education_expense
      t.boolean :other_inflation
      t.boolean :pension_inflation
      t.boolean :socialsecurity_inflation
      t.integer :other_startage
      t.integer :other_income
      t.integer :pension_startage
      t.integer :pension_income
      t.integer :socialsecurity_startage
      t.integer :socialsecurity_income
      t.float :bonds_ret_ret
      t.float :intlstocks_ret_ret
      t.float :usstocks_ret_ret
      t.float :bonds_ret_pre
      t.float :intlstocks_ret_pre
      t.float :usstocks_ret_pre
      t.integer :bonds_alloc_ret
      t.integer :intlstocks_alloc_ret
      t.integer :usstocks_alloc_ret
      t.integer :bonds_alloc_pre
      t.integer :intlstocks_alloc_pre
      t.integer :usstocks_alloc_pre
      t.boolean :taxaccount_inflation
      t.boolean :rothira_inflation
      t.boolean :tradira_inflation
      t.boolean :retplan_inflation
      t.integer :taxaccount_savings
      t.integer :taxaccount_assets
      t.integer :rothira_savings
      t.integer :rothira_assets
      t.integer :tradira_savings
      t.integer :tradira_assets
      t.integer :retplan_savings
      t.integer :retplan_assets
      t.integer :life_expectancy
      t.integer :retirement_age
      t.integer :current_age

      t.timestamps

    end
  end
end
