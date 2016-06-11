class ScenariosController < ApplicationController
  def index
    @scenarios = Scenario.all
  end

  def show
    @scenario = Scenario.find(params[:id])
  end

  def new
    @scenario = Scenario.new
  end

  def retirement
    @scenario = Scenario.find(params[:id])
    @length = @scenario.life_expectancy - @scenario.current_age + 1
    @retirement_year = @scenario.retirement_startage - @scenario.current_age + 1
    if @scenario.education_startage.blank? || @scenario.education_startage.blank?
      noeducation = true
    else
      @educ_begin = @scenario.education_startage - @scenario.current_age + 1
      @educ_end = @scenario.education_endage - @scenario.current_age + 1
      noeducation = false
    end
    @age = Array.new(@length,0)
    @account_balance = Array.new(@length,0)
    @savings = Array.new(@length,0)
    @income_soc_sec = Array.new(@length,0)
    @income_pension = Array.new(@length,0)
    @income_other = Array.new(@length,0)
    @portfolio_distributions = Array.new(@length,0)
    @est_tax = Array.new(@length,0)
    @inv_return = Array.new(@length,0)
    @annual_spending = Array.new(@length,0)
    @preret_return = ((@scenario.usstocks_alloc_pre  * @scenario.usstocks_ret_pre) + (@scenario.intlstocks_alloc_pre * @scenario.intlstocks_ret_pre) + (@scenario.bonds_alloc_pre * @scenario.bonds_ret_pre)) / 10000
    @ret_return = ((@scenario.usstocks_alloc_ret  * @scenario.usstocks_ret_ret) + (@scenario.intlstocks_alloc_ret * @scenario.intlstocks_ret_ret) + (@scenario.bonds_alloc_ret * @scenario.bonds_ret_ret)) / 10000
    @inflation = Array.new(@length,0.0)
    @port_income = Array.new(@length,0)

    @account_balance[1] = @scenario.taxaccount_assets + @scenario.rothira_assets + @scenario.tradira_assets + @scenario.retplan_assets
    @inflation[1] = 1

    (1..@length).each do |x|
      @age[x] = @scenario.current_age + x - 1
      if x > 1
        @inflation[x] = @inflation[x-1] * (1 + (@scenario.inflation_rate / 100.0))
        @account_balance[x] = @account_balance[x-1] + @inv_return[x-1] + @savings[x-1] - ( @portfolio_distributions[x-1] + @est_tax[x-1])
      end
      if x < @retirement_year
        @inv_return[x] = @account_balance[x] * @preret_return
      else
        @inv_return[x] = @account_balance[x] * @ret_return
      end
      if @inv_return[x] < 0
        @inv_return[x] = 0
      end
      if x >= @scenario.socialsecurity_startage - @scenario.current_age + 1
        @income_soc_sec[x] = @scenario.socialsecurity_income * @inflation[x]
      end
      if x >= @scenario.pension_startage - @scenario.current_age + 1
        if @scenario.pension_inflation == true
          @income_pension[x] = @scenario.pension_income * @inflation[x]
        else
          @income_pension[x] = @scenario.pension_income
        end
      end
      if x >= @scenario.other_startage - @scenario.current_age + 1
        if @scenario.other_inflation == true
          @income_other[x] = @scenario.other_income * @inflation[x]
        else
          @income_other[x] = @scenario.other_income
        end
      end
      if x < @retirement_year
        if @scenario.retplan_inflation == true
          retsavings = @scenario.retplan_savings * @inflation[x]
        else
          retsavings = @scenario.retplan_savings
        end
        if @scenario.tradira_inflation == true
          tradsavings = @scenario.tradira_savings * @inflation[x]
        else
          tradsavings = @scenario.tradira_savings
        end
        if @scenario.rothira_inflation == true
          rothsavings = @scenario.rothira_savings * @inflation[x]
        else
          rothsavings = @scenario.rothira_savings
        end
        if @scenario.taxaccount_inflation == true
          taxsavings = @scenario.taxaccount_savings * @inflation[x]
        else
          taxsavings = @scenario.taxaccount_savings
        end
        @savings[x] = retsavings + tradsavings + rothsavings + taxsavings
      end
      @annual_spending[x] = 0
      if noeducation == false
        if x >= @educ_begin && x <= @educ_end
          if @scenario.education_inflation == true
            @annual_spending[x] = @annual_spending[x] + (@scenario.education_expense * @inflation[x])
          else
            @annual_spending[x] = @annual_spending[x] + @scenario.education_expense
          end
        end
      end
      if x >= @retirement_year
        if @scenario.retirement_inflation == true
          @annual_spending[x] = @annual_spending[x] + (@scenario.retirement_income * @inflation[x])
        else
          @annual_spending[x] = @annual_spending[x] + @scenario.retirement_income
        end
      end
      guar_income = (@income_soc_sec[x] + @income_pension[x]+ @income_other[x])
      if @annual_spending[x] > @account_balance[x] + guar_income
        @annual_spending[x] = @account_balance[x] + guar_income
      end

      if @annual_spending[x] < guar_income
        @account_balance[x] = @account_balance[x] + guar_income - @annual_spending[x]
        @annual_spending[x] = guar_income
      end
      @portfolio_distributions[x] = @annual_spending[x] - guar_income
      @est_tax[x] = @portfolio_distributions[x] * (@scenario.ret_taxrate / 100.0)
      @port_income[x] = @annual_spending[x] - guar_income
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Account Balance")
      f.xAxis(categories: @age)
      f.series(name: "Account Balance", yAxis: 0, data: @account_balance)

      f.chart({defaultSeriesType: "area"})
    end
    @bar = LazyHighCharts::HighChart.new('column') do |f|
      f.series(:name=>'Savings',:data=> @savings)
      f.series(:name=>'Portfolio Spending',:data=> @port_income)
      f.series(:name=>'Social Security Income',:data=> @income_soc_sec)
      f.series(:name=>'Pension Income',:data=> @income_pension)
      f.series(:name=>'Other Income',:data=> @income_other)
      f.xAxis(categories: @age)
      f.title({ :text=>"Saving and Spending"})
      f.options[:chart][:defaultSeriesType] = "column"
      f.plot_options({:column=>{:stacking=>"normal"}})
    end
    @savings[@length] = 0
  end

  def create
    @scenario = Scenario.new
    @scenario.user_id = params[:user_id]
    @scenario.description = params[:description]
    @scenario.name = params[:name]
    @scenario.ret_taxrate = params[:ret_taxrate]
    @scenario.inflation_rate = params[:inflation_rate]
    @scenario.retirement_inflation = params[:retirement_inflation]
    @scenario.education_inflation = params[:education_inflation]
    @scenario.retirement_startage = params[:retirement_startage]
    @scenario.retirement_income = params[:retirement_income]
    @scenario.education_endage = params[:education_endage]
    @scenario.education_startage = params[:education_startage]
    @scenario.education_expense = params[:education_expense]
    @scenario.other_inflation = params[:other_inflation]
    @scenario.pension_inflation = params[:pension_inflation]
    @scenario.socialsecurity_inflation = params[:socialsecurity_inflation]
    @scenario.other_startage = params[:other_startage]
    @scenario.other_income = params[:other_income]
    @scenario.pension_startage = params[:pension_startage]
    @scenario.pension_income = params[:pension_income]
    @scenario.socialsecurity_startage = params[:socialsecurity_startage]
    @scenario.socialsecurity_income = params[:socialsecurity_income]
    @scenario.bonds_ret_ret = params[:bonds_ret_ret]
    @scenario.intlstocks_ret_ret = params[:intlstocks_ret_ret]
    @scenario.usstocks_ret_ret = params[:usstocks_ret_ret]
    @scenario.bonds_ret_pre = params[:bonds_ret_pre]
    @scenario.intlstocks_ret_pre = params[:intlstocks_ret_pre]
    @scenario.usstocks_ret_pre = params[:usstocks_ret_pre]
    @scenario.bonds_alloc_ret = params[:bonds_alloc_ret]
    @scenario.intlstocks_alloc_ret = params[:intlstocks_alloc_ret]
    @scenario.usstocks_alloc_ret = params[:usstocks_alloc_ret]
    @scenario.bonds_alloc_pre = params[:bonds_alloc_pre]
    @scenario.intlstocks_alloc_pre = params[:intlstocks_alloc_pre]
    @scenario.usstocks_alloc_pre = params[:usstocks_alloc_pre]
    @scenario.taxaccount_inflation = params[:taxaccount_inflation]
    @scenario.rothira_inflation = params[:rothira_inflation]
    @scenario.tradira_inflation = params[:tradira_inflation]
    @scenario.retplan_inflation = params[:retplan_inflation]
    @scenario.taxaccount_savings = params[:taxaccount_savings]
    @scenario.taxaccount_assets = params[:taxaccount_assets]
    @scenario.rothira_savings = params[:rothira_savings]
    @scenario.rothira_assets = params[:rothira_assets]
    @scenario.tradira_savings = params[:tradira_savings]
    @scenario.tradira_assets = params[:tradira_assets]
    @scenario.retplan_savings = params[:retplan_savings]
    @scenario.retplan_assets = params[:retplan_assets]
    @scenario.life_expectancy = params[:life_expectancy]
    @scenario.retirement_age = params[:retirement_age]
    @scenario.current_age = params[:current_age]

    if @scenario.save
      redirect_to "/scenarios", :notice => "Scenario created successfully."
    else
      render 'new'
    end
  end

  def edit
    @scenario = Scenario.find(params[:id])
  end

  def update
    @scenario = Scenario.find(params[:id])

    @scenario.user_id = params[:user_id]
    @scenario.description = params[:description]
    @scenario.name = params[:name]
    @scenario.ret_taxrate = params[:ret_taxrate]
    @scenario.inflation_rate = params[:inflation_rate]
    @scenario.retirement_inflation = params[:retirement_inflation]
    @scenario.education_inflation = params[:education_inflation]
    @scenario.retirement_startage = params[:retirement_startage]
    @scenario.retirement_income = params[:retirement_income]
    @scenario.education_endage = params[:education_endage]
    @scenario.education_startage = params[:education_startage]
    @scenario.education_expense = params[:education_expense]
    @scenario.other_inflation = params[:other_inflation]
    @scenario.pension_inflation = params[:pension_inflation]
    @scenario.socialsecurity_inflation = params[:socialsecurity_inflation]
    @scenario.other_startage = params[:other_startage]
    @scenario.other_income = params[:other_income]
    @scenario.pension_startage = params[:pension_startage]
    @scenario.pension_income = params[:pension_income]
    @scenario.socialsecurity_startage = params[:socialsecurity_startage]
    @scenario.socialsecurity_income = params[:socialsecurity_income]
    @scenario.bonds_ret_ret = params[:bonds_ret_ret]
    @scenario.intlstocks_ret_ret = params[:intlstocks_ret_ret]
    @scenario.usstocks_ret_ret = params[:usstocks_ret_ret]
    @scenario.bonds_ret_pre = params[:bonds_ret_pre]
    @scenario.intlstocks_ret_pre = params[:intlstocks_ret_pre]
    @scenario.usstocks_ret_pre = params[:usstocks_ret_pre]
    @scenario.bonds_alloc_ret = params[:bonds_alloc_ret]
    @scenario.intlstocks_alloc_ret = params[:intlstocks_alloc_ret]
    @scenario.usstocks_alloc_ret = params[:usstocks_alloc_ret]
    @scenario.bonds_alloc_pre = params[:bonds_alloc_pre]
    @scenario.intlstocks_alloc_pre = params[:intlstocks_alloc_pre]
    @scenario.usstocks_alloc_pre = params[:usstocks_alloc_pre]
    @scenario.taxaccount_inflation = params[:taxaccount_inflation]
    @scenario.rothira_inflation = params[:rothira_inflation]
    @scenario.tradira_inflation = params[:tradira_inflation]
    @scenario.retplan_inflation = params[:retplan_inflation]
    @scenario.taxaccount_savings = params[:taxaccount_savings]
    @scenario.taxaccount_assets = params[:taxaccount_assets]
    @scenario.rothira_savings = params[:rothira_savings]
    @scenario.rothira_assets = params[:rothira_assets]
    @scenario.tradira_savings = params[:tradira_savings]
    @scenario.tradira_assets = params[:tradira_assets]
    @scenario.retplan_savings = params[:retplan_savings]
    @scenario.retplan_assets = params[:retplan_assets]
    @scenario.life_expectancy = params[:life_expectancy]
    @scenario.retirement_age = params[:retirement_age]
    @scenario.current_age = params[:current_age]

    if @scenario.save
      redirect_to "/scenarios", :notice => "Scenario updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @scenario = Scenario.find(params[:id])

    @scenario.destroy

    redirect_to "/scenarios", :notice => "Scenario deleted."
  end
end
