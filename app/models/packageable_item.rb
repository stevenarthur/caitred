class PackageableItem < ActiveRecord::Base
  include Cake::Money

  belongs_to :menu_category

  # Parent / Child thing for packages.
  belongs_to :parent, :class_name => "PackageableItem"
  has_many :subitems, :foreign_key => "parent_id", class_name: "PackageableItem"
  has_paper_trail

  before_save :set_item_type
  before_save :remove_parent_if_empty_string

  scope :by_food_partner, lambda {|food_partner|
    where('? = food_partner_id', food_partner.id)
  }
  scope :with_title, lambda {|title|
    where('? = title', title)
  }
  scope :by_sort_order, -> { order(sort_order: :asc) }
  scope :food, -> { where(item_type: 'food') }
  scope :equipment, -> { where(item_type: 'equipment') }
  scope :vegetarian, -> { where(item_type: 'food', vegetarian: true) }
  scope :vegan, -> { where(item_type: 'food', vegan: true) }
  scope :gluten_free, -> { where(item_type: 'food', gluten_free: true) }
  scope :by_title, -> { order(:title) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :for_event, -> event_type { where('? = ANY (event_type)', event_type) }
  scope :top_level_items, -> { where(parent_id: nil) } 
  scope :active_top_level_packages, -> { where(parent_id: nil, active: true, is_package: true)} 

  belongs_to :food_partner
  validates :title, :cost, presence: true
  validates :cost, numericality: { only_integer: false }

  ALLOWED_PARAMS = [
    :sort_order,
    :parent_id,
    :title,
    :description,
    :cost,
    :cost_to_youchews,
    :item_type,
    :vegetarian,
    :vegetarian_options_available,
    :vegan,
    :gluten_free,
    :gluten_free_options_available,
    :halal,
    :nut_free,
    :contains_nuts,
    :minimum_order,
    :maximum_order,
    :xero_item_id,
    :what_you_get,
    :is_package,
    :active,
    :presentation,
    :menu_category_id,
    :package_conditions,
    event_type: []
  ]

  DIETARY_PROPERTIES = {
    vegetarian: 'v',
    vegan: 'vg',
    gluten_free: 'gf'
  }

  def self.allowed_params
    ALLOWED_PARAMS
  end

  def to_hash
    {
      id: id,
      title: title,
      cost: cost,
      cost_string: cost_string
    }
  end

  def dietary_acronyms
    property_string = DIETARY_PROPERTIES.collect do |property, acronym|
      acronym if send(property)
    end.delete_if(&:nil?).join(', ')
    return '' if property_string.blank?
    "(#{property_string})"
  end

  def suitable_for
    SpecialDiets.all.collect do |diet|
      diet.group_name if send(diet.to_method_name)
    end.delete_if(&:nil?).join(' and ')
  end

  def dietary_desc
    SpecialDiets.all.collect do |diet|
      diet.name if send(diet.to_method_name)
    end.delete_if(&:nil?).join(', ')
  end

  def package?
    is_package?
  end

  private

  def set_item_type
    self[:item_type] = 'food' if self[:item_type].nil?
  end

  # In an ideal world, this shouldnt be there. 
  def remove_parent_if_empty_string
    self[:parent_id] = nil if self[:parent_id] == ""
  end
end
