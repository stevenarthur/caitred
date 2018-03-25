class MenuTag < ActiveRecord::Base
  include Comparable

  scope :filters, -> { where(is_filter: true) }

  def to_s
    tag
  end

  def menu_count
    menus.size
  end

  def menus
    Menu.with_tag(tag)
  end

  def <=>(other)
    tag <=> other.tag
  end

  def ==(other)
    hash == other.hash
  end
end
