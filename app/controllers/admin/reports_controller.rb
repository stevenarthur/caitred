module Admin
  class ReportsController < AdminController
    before_action :require_admin_authentication

    def index
    end

    def completed_orders
      @orders = Enquiry.completed.order(created_at: :desc)
    end

    def weekly
      set_weekly_start_date
      set_weekly_end_date
      @weekly_reports = []
      populate_weekly_reports
    end

    def monthly
      set_monthly_start_date
      set_monthly_end_date
      @monthly_reports = []
      populate_monthly_reports
    end

    def customers
      connection = Enquiry.connection
      @customer_reports = CustomerReport.new(connection)
    end

    private

    def populate_monthly_reports
      connection = Enquiry.connection
      current_date = @start_date
      while current_date < @end_date
        report = Report.new(connection, current_date, current_date + 1.months)
        @monthly_reports.insert(0, report)
        current_date += 1.months
      end
    end

    def populate_weekly_reports
      connection = Enquiry.connection
      current_date = @start_date
      while current_date < @end_date
        report = Report.new(connection, current_date, current_date + 1.weeks)
        @weekly_reports.insert(0, report)
        current_date += 1.weeks
      end
    end

    def set_monthly_start_date
      @start_date = Time.parse(params[:start_date])
    rescue
      @start_date = Time.now.beginning_of_month - 5.months
    end

    def set_monthly_end_date
      @end_date = Time.parse(params[:end_date])
    rescue
      @end_date = Time.now
    end

    def set_weekly_start_date
      @start_date = Time.parse(params[:start_date])
    rescue
      @start_date = Time.now.end_of_week - 12.weeks
    end

    def set_weekly_end_date
      @end_date = Time.parse(params[:end_date])
    rescue
      @end_date = Time.now.end_of_week
    end
  end
end
