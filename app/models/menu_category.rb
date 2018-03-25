class MenuCategory < ActiveRecord::Base
  belongs_to :food_partner
  default_scope {  order(sort_order: :asc) }

  has_many :packageable_items, dependent: :nullify

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, :sort_order, presence: true
end
