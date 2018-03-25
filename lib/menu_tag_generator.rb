class MenuTagGenerator
  def self.generate
    all_tags.each { |tag| ensure_tag(tag) }
    MenuTag.all.each { |tag| check_filterable(tag) }
  end

  def self.check_filterable(tag)
    menus = Menu.with_tag(tag).size
    tag.update_attributes!(is_filter: false) unless menus > 0
  end

  def self.ensure_tag(tag)
    MenuTag.create!(tag: tag, is_filter: false) if MenuTag.find_by_tag(tag).nil?
  end

  def self.all_tags
    Menu.all.map(&:tags).flatten.uniq
  end
end
