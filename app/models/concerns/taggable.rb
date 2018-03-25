module Taggable
  extend ActiveSupport::Concern

  included do
    scope :with_tag, lambda {|tag|
      where('? = ANY (tags)', tag.to_s)
    }
  end

  def tags=(tags)
    tags = tags.split(',') if tags.is_a? String
    tags.try(:each, &:strip!)
    self[:tags] = tags
  end

  def tag_string
    tags.join(', ')
  end
end
