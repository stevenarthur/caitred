class EventDetails < Cake::PropertyBase
  allowed_property :event_date, :event_time, :attendees, :budget

  def self.allowed_params
    [
      :event_date,
      :event_time,
      :attendees,
      :budget
    ]
  end

  def event_date
    return nil if @properties.fetch(:event_date, '').blank?
    if @properties[:event_date].include?('/')
      base = @properties[:event_date].split('/')
      Time.parse "#{base[1]}-#{base[0]}-#{base[2]}"
    else  
      Time.parse @properties[:event_date]
    end
  end

  def delivery_time
    (event_time.to_time - 15.minutes).strftime("%H:%M %p")
  end

  def to_h
    hash = super
    hash[:event_date] = event_date.try(:strftime, '%d %B %Y')
    hash
  end
end
