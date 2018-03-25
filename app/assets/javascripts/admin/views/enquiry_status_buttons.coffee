Cake.Templates.EnquiryStatusButtons = Haml '''
  :if (can_progress == 'true')
    %a.js-progress-enquiry.btn.btn-inline.btn-default{ data-id: enquiryId }
      Move to #{next_status}
  :if (can_cancel == 'true')
    %a.js-cancel-enquiry.btn.btn-inline.btn-default{ data-id: enquiryId, title: 'Cancel' }
      X
  :if (can_mark_test_or_spam == 'true')
    %a.js-mark-enquiry-test.btn.btn-inline-icon.btn-default{ data-id: enquiryId, title: 'Mark as Test' }
      %i.icon-icon_34525.icon-medium{ data-id: enquiryId }
    %a.js-mark-enquiry-spam.btn.btn-inline-icon.btn-default{ data-id: enquiryId, title: 'Mark as Spam' }
      %i.icon-icon_61684.icon-medium{ data-id: enquiryId }
'''
