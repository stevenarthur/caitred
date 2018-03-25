class EventDetailsForm < Reform::Form
  include Reform::Form::ActiveRecord
  
  property :event_date
  validates :event_date, presence: true  
end