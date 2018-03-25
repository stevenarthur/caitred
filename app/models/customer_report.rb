class CustomerReport
  def initialize(conn)
    @conn = conn
  end

  def weekly_customers
    populate_customers if @last_three_months.nil?
    @last_three_months.count do |customer|
      customer[report_columns[:order_count]].to_i >= 6
    end
  end

  def regular_customers
    populate_customers if @customers.nil?
    regular_customers = @customers.count do |customer|
      customer[report_columns[:order_count]].to_i >= 4
    end
    regular_customers - weekly_customers
  end

  def repeat_customers
    populate_customers if @customers.nil?
    @customers.count do |customer|
      customer[report_columns[:order_count]].to_i.between?(2, 3)
    end
  end

  def new_customers
    populate_customers if @customers.nil?
    @customers.count do |customer|
      customer[report_columns[:order_count]].to_i == 1
    end
  end

  private

  def populate_customers
    last_three_months = <<-SQL
      select * from
      customer_order_count_by_date('#{three_months_ago}','#{Time.now.strftime('%d %B %Y')}')
    SQL
    @last_three_months = @conn.select_rows(last_three_months)
    sql = <<-SQL
      select * from
      customer_order_count_by_date('#{one_year_ago}','#{Time.now.strftime('%d %B %Y')}')
    SQL
    @customers ||= @conn.select_rows(sql)
  end

  def three_months_ago
    (Time.now - 3.months).strftime('%d %B %Y')
  end

  def one_year_ago
    (Time.now - 1.year).strftime('%d %B %Y')
  end

  def report_columns
    {
      customer_id: 0,
      order_count: 1
    }
  end
end
