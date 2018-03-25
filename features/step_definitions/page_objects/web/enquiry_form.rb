module Web
  class EnquiryForm < BasePage
    def self.enquiry_for_menu(menu_title)
      menu = Menu.find_by_title(menu_title)
      "/enquiries/new/menu/#{menu.id}"
    end

    def self.enquiry
      '/enquiries/new'
    end

    def menu_panel
      MenuPanel.new(@page)
    end

    def show_calendar
      @page.find('#js-show-datepicker').click
    end

    def show_clock
      @page.find('#js-show-timepicker').click
    end

    def calendar
      Calendar.new(@page)
    end

    def clock
      @page.find('.bootstrap-timepicker-widget.dropdown-menu')
    end

    def fill_event_date(date)
      fill_in 'js-event-date', date.strftime('%e %b %Y')
    end

    def fill_event_time(date)
      fill_in 'js-event-time', date.strftime('%l:%M %p')
    end

    def add_food_choice(choice)
      id_string = "#js-food-request-#{choice.downcase.gsub(' ', '-')}"
      @page.find(id_string).set(true)
    end

    def add_dietary_requirement(choice)
      id_string = "#js-dr-#{choice.downcase.gsub(' ', '-')}"
      @page.find(id_string).set(true)
    end

    def fill_dietary_requirements_text(text)
      fill_in 'js-dietary-text', text
    end

    def add_extra(extra)
      id_string = "#js-extra-#{extra.downcase.gsub(' ', '-')}"
      @page.find(id_string).set(true)
    end

    def fill_name(name)
      fill_in 'js-first-name', name
    end

    def fill_comm_preference(preference)
      id_string = "#js-comms-#{preference.downcase}"
      @page.find(id_string).set(true)
    end

    def opt_out_of_mailings
      @page.find('#js-opt-out').set(true)
    end

    def close_alert
      @page.find('.navbar-fixed-bottom .close').click
    end

    def accept_terms
      @page.find('#js-accept-terms').set(true)
    end

    def validation_errors?
      @page.all('.js-errors:not(:empty)').count > 0
    end

    def validation_errors
      @page.all('.js-errors:not(:empty)').map(&:text)
    end

    def submit
      @page.click_button 'Send Enquiry'
      @page.find('.js-enquiry-thanks')
    end

    def attempt_submit
      @page.click_button 'Send Enquiry'
    end

    def contact_name
      @page.find('#js-contact-name').text
    end

    def contact_email
      @page.find('#js-contact-email').text
    end

    def address_line_1
      @page.find('#js-address-text-line-1').text
    end

    def address_suburb
      @page.find('#js-address-text-suburb').text
    end

    def edit_address
      @page.find('#js-edit-address').click
    end

    def add_address
      @page.find('#js-add-address').click
    end
  end
end
