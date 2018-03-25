class EnquiryStatus
  def initialize(name, method = :status=)
    @name = name
    @method = method
  end

  def execute(enquiry)
    enquiry.send(@method, @name)
  end

  def to_s
    @name
  end

  PENDING_PAYMENT = 'Pending Payment'
  NEW = 'New'
  PROCESSING = 'Processing'
  WAITING_ON_SUPPLIER = 'Waiting on Supplier'
  READY_TO_CONFIRM = 'Ready to Confirm'
  CONFIRMED = 'Confirmed'
  DELIVERED = 'Delivered'
  COMPLETED = 'Completed'
  SPAM = 'Spam'
  CANCELLED = 'Cancelled'
  TEST = 'Test'

  WORKFLOW = {
    NEW => EnquiryStatus.new(PROCESSING),
    PROCESSING => EnquiryStatus.new(WAITING_ON_SUPPLIER),
    WAITING_ON_SUPPLIER => EnquiryStatus.new(READY_TO_CONFIRM, :create_confirm_link),
    READY_TO_CONFIRM => EnquiryStatus.new(CONFIRMED),
    CONFIRMED => EnquiryStatus.new(DELIVERED),
    DELIVERED => EnquiryStatus.new(COMPLETED)
  }

  REGRESSION = {
    COMPLETED => EnquiryStatus.new(DELIVERED),
    DELIVERED => EnquiryStatus.new(CONFIRMED),
    CONFIRMED => EnquiryStatus.new(READY_TO_CONFIRM),
    READY_TO_CONFIRM => EnquiryStatus.new(WAITING_ON_SUPPLIER),
    WAITING_ON_SUPPLIER => EnquiryStatus.new(PROCESSING),
    PROCESSING => EnquiryStatus.new(NEW)
  }

  VALUE = {
    NEW => 1,
    PROCESSING => 2,
    WAITING_ON_SUPPLIER => 3,
    READY_TO_CONFIRM => 4,
    CONFIRMED => 5,
    DELIVERED => 6,
    COMPLETED => 7,
    CANCELLED => 100,
    SPAM => 101,
    TEST => 102
  }

  def self.progress(enquiry)
    error_msg = 'Enquiry cannot be progressed through workflow'
    fail error_msg unless can_progress?(enquiry.status)
    next_status(enquiry.status).execute(enquiry)
  end

  def self.regress(enquiry)
    error_msg = 'Enquiry cannot be regressed through workflow'
    fail error_msg unless can_regress?(enquiry.status)
    last_status(enquiry.status).execute(enquiry)
  end

  def self.next_status(status)
    WORKFLOW[status]
  end

  def self.last_status(status)
    REGRESSION[status]
  end

  def self.can_progress?(status)
    WORKFLOW.keys.include?(status)
  end

  def self.value_of(status)
    VALUE[status]
  end

  def self.can_regress?(status)
    REGRESSION.keys.include?(status)
  end

  def self.can_cancel?(status)
    [
      NEW,
      PROCESSING,
      WAITING_ON_SUPPLIER,
      READY_TO_CONFIRM,
      CONFIRMED
    ].include? status
  end

  def self.can_mark_test_or_spam?(status)
    [NEW, PROCESSING].include? status
  end

  def self.awaiting_confirmation
    [
      NEW,
      PROCESSING,
      WAITING_ON_SUPPLIER,
      READY_TO_CONFIRM
    ]
  end

  def self.awaiting_completion
    [
      CONFIRMED,
      DELIVERED
    ]
  end

  def self.post_confirmation?(status)
    [
      CONFIRMED,
      DELIVERED,
      COMPLETED
    ].include?(status)
  end
end
