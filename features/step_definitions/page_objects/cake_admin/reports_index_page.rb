module Admin
  class ReportsIndexPage < BasePage
    def self.url
      '/admin/reports/index'
    end

    def click_completed_orders
      @page.find('#js-completed-orders').click
    end

    def click_weekly_summary
      @page.find('#js-weekly-summary').click
    end

    def click_monthly_summary
      @page.find('#js-monthly-summary').click
    end

    def click_summary_by_date
      @page.find('#js-summary-by-date').click
    end

    def completed_orders_link?
      !@page.first('#js-completed-orders').nil?
    end

    def weekly_link?
      !@page.first('#js-weekly-summary').nil?
    end

    def monthly_link?
      !@page.first('#js-monthly-summary').nil?
    end

    def customer_link?
      !@page.first('#js-customer-report').nil?
    end
  end
end
