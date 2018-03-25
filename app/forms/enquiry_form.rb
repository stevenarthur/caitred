class EnquiryForm < Reform::Form
  include Reform::Form::ActiveRecord
  include Reform::Form::ActiveModel::FormBuilderMethods

  model :enquiry

  validates :event_date, presence: true
  validates :event_time, presence: true

end
