module FoodPartnerHelper
  def tab_class(tab_name)
    @tab ||= :food_partner
    return 'active' if @tab == tab_name
  end

  def opening_hours_today(food_partner)
  end

  def days_off(food_partner)
    days_in = (food_partner.delivery_days || 
               "monday,tuesday,wednesday,thursday,friday,saturday,sunday" ) 
    s = ''
    days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
    days.each_with_index do |d, i|
      unless days_in.include?(d)
        s += i.to_s + ' '
      end
    end  
    s
  end
end
