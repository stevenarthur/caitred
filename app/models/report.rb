class Report
  include Cake::HasPrice

  attr_reader :start_date, :end_date

  def initialize(conn, start_date, end_date)
    @conn = conn
    @start_date = start_date
    @end_date = end_date
  end

  def confirmed_enquiry_count
    confirmed_enquiries.size
  end

  def average_enquiry_value
    return 0 if confirmed_enquiry_count == 0
    total_revenue / confirmed_enquiry_count
  end

  def total_revenue
    confirmed_enquiries.reduce 0 do |sum, enquiry|
      amount_paid = enquiry[confirmed_enquiries_columns[:total_amount_paid]].to_f || 0
      sum + amount_paid
    end
  end

  def gross_profit
    total_revenue - total_cost_to_us
  end

  def new_customer_count
    new_customers.size
  end

  def meals_served
    enquiries_fulfilled.reduce 0 do |sum, enquiry|
      attendees_string = enquiry[enquiries_fulfilled_columns[:attendees]].to_s
      attendees_int = attendees_string.gsub('"', '').to_i
      sum + attendees_int
    end
  end

  def orders_fulfilled
    enquiries_fulfilled.size
  end

  def new_enquiries_count
    new_enquiries.size
  end

  private

  def total_cost_to_us
    confirmed_enquiries.reduce 0 do |sum, enquiry|
      cost = enquiry[confirmed_enquiries_columns[:total_cost_to_us]].to_f || 0
      cost += enquiry[confirmed_enquiries_columns[:payment_fee_paid]].to_f || 0
      sum + cost
    end
  end

  def new_customers
    sql = <<-SQL
      select * from customer_order_count
      where created_at >= '#{@start_date.utc}'
      and created_at <= '#{@end_date.utc}'
    SQL
    @new_customers ||= @conn.select_rows(sql)
  end

  def confirmed_enquiries
    sql = <<-SQL
      select * from confirmed_enquiries
      where confirmed_at >= '#{@start_date.utc}'
      and confirmed_at <= '#{@end_date.utc}'
    SQL
    @confirmed_enquiries ||= @conn.select_rows(sql)
  end

  def confirmed_enquiries_columns
    columns = @conn.columns('confirmed_enquiries')
              .map(&:name)
              .map(&:to_sym)
    Hash[columns.map.with_index.to_a]
  end

  def enquiries_fulfilled
    sql = <<-SQL
      select * from enquiry_event_date_and_attendees
      where to_date >= '#{@start_date.utc}'
      and to_date <= '#{@end_date.utc}'
    SQL
    @enquiries_fulfilled ||= @conn.select_rows(sql)
  end

  def enquiries_fulfilled_columns
    columns = @conn.columns('enquiry_event_date_and_attendees')
              .map(&:name)
              .map(&:to_sym)
    Hash[columns.map.with_index.to_a]
  end

  def new_enquiries
    sql = <<-SQL
      select id from enquiries
      where created_at >= '#{@start_date.utc}'
      and created_at <= '#{@end_date.utc}'
      and status != '#{EnquiryStatus::CANCELLED}'
      and status != '#{EnquiryStatus::SPAM}'
      and status != '#{EnquiryStatus::TEST}'
    SQL
    @new_enquiries ||= @conn.select_rows(sql)
  end
end
