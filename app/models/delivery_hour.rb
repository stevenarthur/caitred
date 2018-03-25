class DeliveryHour < ActiveRecord::Base
  belongs_to :food_partner, inverse_of: :delivery_hours
  enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  validates :food_partner, :day, :start_time, :end_time, presence: true
  validate :opening_hours_dont_overlap_for_same_food_partner

  def self.string_to_seconds(string)
    newstring = string.gsub(".", ":")
    Time.zone.parse(newstring).seconds_since_midnight
  end

  def self.all_available_hours
    start_of_day = (Time.zone.now.at_beginning_of_day)
    end_of_day = (Time.zone.now.at_end_of_day)
    [start_of_day].tap { |array| array << array.last + 15.minutes while array.last < end_of_day }
  end

  # Should be extracted to a decorator class eventually
  def friendly_start_time
    time = Time.zone.now.at_beginning_of_day.since(start_time)
    time.strftime("%l:%M %p").strip
  end

  # Should be extracted to a decorator class eventually
  def friendly_end_time
    time = Time.zone.now.at_beginning_of_day.since(end_time)
    time.strftime("%l:%M %p").strip
  end

  # Returns times in 15 minute increments
  def selectable_times
    midnight = Time.zone.now.at_beginning_of_day
    time_start = midnight.since(start_time)
    time_end = midnight.since(end_time)
    increments = [time_start].tap { |array| array << array.last + 15.minutes while array.last < time_end }
  end

  def formattable_times
    selectable_times.map{ |time| time.strftime("%l:%M %p").strip }
  end

private

  def opening_hours_dont_overlap_for_same_food_partner
    times = DeliveryHour.where(food_partner_id: food_partner_id, day: DeliveryHour.days[day])
                        .pluck(:start_time, :end_time)
    return true if times.size <= 1
    opening_times = times.map{ |time| time[0]..time[1] }
    opening_times.each do |time_range|
      errors.add(:start_time, 'Overlapping opening hours') if time_range.include?(start_time)
      errors.add(:end_time, 'Overlapping opening hours') if time_range.include?(end_time)
    end
  end

end
