RSpec.describe Cashier do
  it "has a version number" do
    expect(Cashier::VERSION).not_to be nil
  end

  describe ".totals" do
    let(:pricing_rules) {
      { "GR1" => { price: 3.11, name: "Grean Tea", discount_qty: 2, discount_price: 1.75 },
        "SR1" => { price: 5, name: "Strawberries", discount_qty: 3, discount_price: 4.5 },
        "CF1" => { price: 11.23, name: "Coffee", discount_qty: 3, discount_price: 7.48 } }
    }
    let(:checkout_instance) { Cashier::Checkout.new pricing_rules }

    context "with no discounts" do
      it "calculates totals correctly" do
        products = ["GR1", "SR1", "CF1"]
        products.each { |code|
          checkout_instance.scan(code)
        }
        expect(checkout_instance.total).to be 19.34
      end
    end

    context "with discounts" do
      it "calculates totals for multiple products" do
        # GR1,SR1,GR1,GR1,CF1
        checkout_instance.scan("GR1")
        checkout_instance.scan("SR1")
        checkout_instance.scan("GR1")
        checkout_instance.scan("GR1")
        checkout_instance.scan("CF1")
        expect(checkout_instance.total).to be 22.45
      end

      it "calculates totals for a single product" do
        # GR1,GR1
        checkout_instance.scan("GR1")
        checkout_instance.scan("GR1")
        expect(checkout_instance.total).to be 3.11
      end

      it "calculates correct discounts for multiple products" do
        # SR1,SR1,GR1,SR1
        checkout_instance.scan("SR1")
        checkout_instance.scan("SR1")
        checkout_instance.scan("GR1")
        checkout_instance.scan("SR1")
        expect(checkout_instance.total).to be 16.61
      end

      it "calculates correct discounts for mixed products" do
        # GR1,CF1,SR1,CF1,CF1
        checkout_instance.scan("GR1")
        checkout_instance.scan("CF1")
        checkout_instance.scan("SR1")
        checkout_instance.scan("CF1")
        checkout_instance.scan("CF1")
        expect(checkout_instance.total).to be 16.61
      end
    end
  end
end
