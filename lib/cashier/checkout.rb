class Cashier::Checkout
  attr_accessor :rules

  def initialize(rules = [])
    @rules = rules
    # Hash of item -> qty, with a default qty of 0
    @cart = Hash.new(0)
  end

  def scan(item)
    unless @rules.include?(item)
      raise Cashier::InvalidItemError
    end

    # increment the item qty by 1
    @cart[item] += 1
  end

  def calculate_discounts(item)
  end

  def total
    result = 0

    @cart.each_pair { |item_code, qty|
      puts "Item code: #{item_code}, Qty: #{qty}"
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
          puts "Item #{item_code}, total: #{item_total}"
          result += item_total
        else
          # Past the discount threshold, and no discount type specified for this item
          raise Cashier::InvalidRulesError
        end
      else
        # Add the price of the item to the total
        result += item_price * qty
      end
    }
    result
  end
end
