# LineItem in a cart scenario.
class EnquiryItem < ActiveRecord::Base
  belongs_to :enquiry
  belongs_to :packageable_item
  has_one :food_partner, through: :packageable_item

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :enquiry_present
  validate :packageable_item_present

  delegate :title, :description, :xero_item_id, to: :packageable_item

  before_save :finalize

  def unit_price
    if persisted?
      self[:unit_price]
    else
      packageable_item.cost
    end
  end

  def total_price
    unit_price * quantity
  end

  def package_price
    price = total_price
    subitem_ids = packageable_item.subitems.pluck(:id)
    enquiry.enquiry_items.where(packageable_item_id: subitem_ids).each do |item|
      price = price + item.total_price  
    end
    return price
  end

  def package_subitems
    subitem_ids = packageable_item.subitems.pluck(:id)
    enquiry.enquiry_items.where(packageable_item_id: subitem_ids)
  end

  def top_level_package_item?
    standard_package || first_option_without_standard_package
  end

  def subpackage_item?
    packageable_item.parent_id != nil
  end

  def package_parent
    if standard_package
      packageable_item.id
    else
      packageable_item.parent.id 
    end
  end


private

  def standard_package
    packageable_item.package? && (packageable_item.parent_id == nil)
  end
  
  # package
  # that has a parent_id
  # where that parent item is not in the cart
  def first_option_without_standard_package
    if packageable_item.package? && packageable_item.parent_id != nil
      if enquiry.enquiry_items.where(packageable_item_id: packageable_item.parent_id).size == 0
        packageable_item_option_ids = packageable_item.parent.subitems.pluck(:id).sort
        packageable_item_option_ids.first == packageable_item.id
      else
        return false
      end
    else
      return false
    end
  end

  def enquiry_present
    if enquiry.nil?
      errors.add(:enquiry, "is not a valid order.")
    end
  end

  def packageable_item_present
    if packageable_item.nil?
      errors.add(:packageable_item, "is not valid or is not active.")
    end
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = quantity * self[:unit_price]
  end

end
