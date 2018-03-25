# encoding: UTF-8

module Cake
  module HasUrlSlug
    extend ActiveSupport::Concern

    included do
      before_save :set_url_slug
    end

    def generate_url_slug_from(name)
      slug = name.gsub(' ', '-').downcase.gsub(/[^a-zA-Z0-9\-]/, '')
      ensure_valid_slug slug
    end

    def ensure_valid_slug(slug)
      return slug if valid_slug? slug
      (1..10).each do |suffix|
        new_slug = slug + '-' + suffix.to_s
        return new_slug if valid_slug? new_slug
      end
    end

    def valid_slug?(slug)
      return false if slug.blank?
      return false unless self.class.find_by_url_slug(slug).nil?
      true
    end

    def set_url_slug
      self[:url_slug] = generate_url_slug unless slug?
    end

    def slug?
      !(url_slug.nil? || url_slug.blank?)
    end
  end
end
