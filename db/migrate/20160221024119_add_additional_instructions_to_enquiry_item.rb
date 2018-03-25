class AddAdditionalInstructionsToEnquiryItem < ActiveRecord::Migration
  def change
    add_column :enquiry_items, :additional_instructions, :text
  end
end
