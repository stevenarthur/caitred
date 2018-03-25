# encoding: UTF-8

require 'rails_helper'

class WithMoney
  include Cake::Money
  attr_accessor :cost
end

describe WithMoney do
  let(:with_money) do
    with_money = WithMoney.new
    with_money.cost = 10
    with_money
  end

  context 'formatting' do

    it 'formats a single dollar amount' do
      expect(with_money.format_money(5)).to eq '$5'
    end

    it 'formats a dollar and cents amount' do
      expect(with_money.format_money(5.37)).to eq '$5.37'
    end

    it 'formats a dollar and cents amount ending in zero' do
      expect(with_money.format_money(5.6)).to eq '$5.60'
    end
  end

  context 'property or method exists' do
    it 'responds to a method with _string appended by formatting as money' do
      expect(with_money.cost_string).to eq '$10'
    end

    it 'formats a method ending _display_string as money' do
      expect(with_money.cost_display_string).to eq '$10'
    end

    context 'method is actualle missing' do
      it 'responds with default behaviour' do
        expect do
          with_money.missing_something
        end.to raise_error NoMethodError
      end

      it 'responds with default behaviour passing args' do
        expect do
          with_money.missing_something(:with, 'args')
        end.to raise_error NoMethodError
      end
    end
  end

  context 'property or method does not exist' do

    shared_examples 'method missing' do

      it 'responds with default method missing behaviour' do
        expect do
          with_money.send(method)
        end.to raise_error NoMethodError
      end

    end

    context 'method contains "_string"' do
      let(:method) { :missing_cost_string }
      it_behaves_like 'method missing'
    end

    context 'method contains "_display_string"' do
      let(:method) { :missing_cost_display_string }
      it_behaves_like 'method missing'
    end
  end
end
