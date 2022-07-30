class Cashier::Checkout
  attr_accessor :rules

  def initialize(rules = [])
    @rules = rules
    # Hash of item -> qty, with a default qty of 0
    @cart = Hash.new(0)
  end

  def scan(item)
    unless @rules.has_key?(item)
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

      # Check if discounts apply, and calculate total
      if qty >= @rules[item_code][:discount_threshold]
        # Calculate total for that specific item
        item_total = @rules[item_code][:discount_calc].call(item_price, qty)
        puts "Item #{item_code}, total: #{item_total}"
        result += item_total
      else
        # Add the price of the item to the total
        result += item_price
      end
    }
    result
  end
end
