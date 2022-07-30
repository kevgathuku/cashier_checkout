class Cashier::Checkout
  attr_accessor :rules

  def initialize(rules = [])
    @rules = rules
    # Hash of item -> qty, with a default of 0
    @cart = Hash.new(0)
  end

  def scan(item)
    unless @rules.has_key?(item)
      raise Cashier::InvalidItemError
    end

    # increment the qty in the cart by 1
    @cart[item] += 1
  end

  def calculate_discounts
  end

  def total
    result = 0
    @cart.each_pair { |item, qty|
      puts @rules[item]
      result += @rules[item][:price]
    }
    result
  end
end
