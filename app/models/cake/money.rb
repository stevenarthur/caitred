# encoding: UTF-8

module Cake
  module Money
    include ActionView::Helpers::NumberHelper

    def format_money(money)
      formatted_money = number_to_currency(money)
      return '' if formatted_money.nil?
      formatted_money.gsub('.00', '')
    end

    def format_money_for_display(money)
      return 'free' if money.nil? || money == 0
      format_money(money)
    end

    def method_missing(method_name, *args)
      result = respond_to(/_display_string$/, :format_money_for_display, method_name)
      result = respond_to(/_string$/, :format_money, method_name) if result.nil?
      if result.nil?
        super
      else
        result
      end
    end

    private

    def respond_to(match, method, method_name)
      return nil unless method_name.match match
      original = method_name.to_s.gsub(match, '').to_sym
      return nil unless respond_to? original
      send(method, send(original))
    end
  end
end
