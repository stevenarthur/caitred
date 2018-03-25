# encoding: UTF-8

require 'business_time'

module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice then 'alert alert-info'
    when :success then 'alert alert-success'
    when :error then 'alert alert-danger'
    when :alert then 'alert alert-danger'
    end
  end

  def days_from_now(days)
    days.business_days.from_now.beginning_of_day
  end

  def cookie_domain
    # Uncomment the line below to test GA changes
    # return "none" unless Rails.env.production?
    'youchews.com'
  end

  def bootstrap_label_tag(name = nil, content = nil, options = nil, &block)
    options ||= {}
    options[:class] = options[:class].to_s.strip << ' control-label'
    options[:class].strip!
    label_tag name, content, options, &block
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def current_page
    case params[:controller]
    when 'web/menus'
      :menus
    when 'welcome'
      :home
    when 'enquiries'
      :enquiry
    when 'static_content'
      :static
    when 'web/specials'
      params[:action]
    when 'web/enquiry_confirmation'
      :enquiry_confirmation
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity

  def word_for_people(number)
    return 'person' if number == 1
    'people'
  end

  def price_string(price_display_string)
    return '(free)' if price_display_string == 'free'
    "(#{price_display_string} per person*)"
  end

  def include_facebook?
    @include_facebook || false
  end

  def livechat?
    case params[:controller]
    when 'welcome'
      false
    else
      true
    end
  end

  def randomized_background_image
    images = ["facebook-bagels.jpg"]
    images[rand(images.size)]
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "js--add_fields btn btn-success", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
