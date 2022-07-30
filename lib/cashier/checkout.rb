class Cashier::Checkout
  attr_accessor :rules

  def initialize(rules = [])
    @rules = rules
    # Hash of item -> qty, with a default qty of 0
    @cart = Hash.new(0)
  end

  def scan(item)
    raise Cashier::InvalidItemError unless @rules.include?(item)

    @cart[item] += 1
  end

  def total
    result = 0

    @cart.each_pair do |item_code, qty|
      item_price = @rules[item_code][:price]
      discount_threshold = @rules[item_code][:discount_threshold]
      discount_price = @rules[item_code][:discount_price]

      # Calculate totals, applying discounts
      if qty >= discount_threshold
        if @rules[item_code].has_key?(:discount_price)
          # Use the discount price instead of the actual price
          result += discount_price * qty
        elsif @rules[item_code].has_key?(:discount_calc)
          # Use the discount_calc proc to calculate the total
          item_total = @rules[item_code][:discount_calc].call(item_price, qty)
          result += item_total
        else
          # Past the discount threshold, and no discount type specified for this item
          raise Cashier::InvalidRulesError
        end
      else
        # No discount. Add the actual price of the item to the total
        result += item_price * qty
      end
    end
    result
  end
end
