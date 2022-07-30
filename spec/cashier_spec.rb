RSpec.describe Cashier do
  it "has a version number" do
    expect(Cashier::VERSION).not_to be nil
  end

  describe ".initialize" do
    let(:checkout_instance) {
      Cashier::Checkout.new {
        { "SR1" => {
          price: 5,
          name: "Strawberries",
          discount_threshold: 3,
          discount_price: 4.5,
        } }
      }
    }

    it "throws when trying to add an invalid item" do
      expect { checkout_instance.scan("XYZ") }.to raise_error Cashier::InvalidItemError
    end
  end

  describe ".total" do
    let(:pricing_rules) {
      { "GR1" => { price: 3.11,
                 name: "Grean Tea",
                 discount_threshold: 2,
                 discount_calc: Proc.new { |price, qty|
        qty.odd? ? (qty.next / 2) * price : (qty / 2) * price
      } },
       "SR1" => {
        price: 5,
        name: "Strawberries",
        discount_threshold: 3,
        discount_price: 4.5,
      },
       "CF1" => {
        price: 11.23,
        name: "Coffee",
        discount_threshold: 3,
        discount_price: 7.48,
      } }
    }
    let(:checkout_instance) { Cashier::Checkout.new pricing_rules }

    context "with invalid data" do
      let(:invalid_pricing_rules) {
        {
          "SR1" => {
            price: 5,
            name: "Strawberries",
            discount_threshold: 3,
          },
        }
      }
      let(:checkout_instance) { Cashier::Checkout.new invalid_pricing_rules }

      it "throws when calculating total with invalid discount rules" do
        # SR1,SR1,SR1
        checkout_instance.scan("SR1")
        checkout_instance.scan("SR1")
        checkout_instance.scan("SR1")
        expect { checkout_instance.total }.to raise_error Cashier::InvalidRulesError
      end
    end

    context "with no discounts" do
      it "calculates totals correctly" do
        products = ["GR1", "SR1", "CF1"]
        products.each { |code|
          checkout_instance.scan(code)
        }
        expect(checkout_instance.total).to be 19.34
      end

      it "calculates totals for strawberries not at the threshold" do
        # SR1,SR1
        checkout_instance.scan("SR1")
        checkout_instance.scan("SR1")
        expect(checkout_instance.total).to be 10
      end

      it "calculates totals for coffee not at the threshold" do
        # SR1,SR1
        checkout_instance.scan("CF1")
        checkout_instance.scan("CF1")
        expect(checkout_instance.total).to be 11.23 * 2
      end
    end

    context "with discounts" do
      it "calculates totals for a BOGOF discount type" do
        # GR1,GR1,GR1
        checkout_instance.scan("GR1")
        checkout_instance.scan("GR1")
        checkout_instance.scan("GR1")
        expect(checkout_instance.total).to be 3.11 * 2
      end

      it "calculates totals for a threshold quantity discount type" do
        # SR1,SR1,SR1
        checkout_instance.scan("SR1")
        checkout_instance.scan("SR1")
        checkout_instance.scan("SR1")
        expect(checkout_instance.total).to be 4.5 * 3
      end

      xit "calculates totals for multiple products" do
        # GR1,SR1,GR1,GR1,CF1
        checkout_instance.scan("GR1")
        checkout_instance.scan("SR1")
        checkout_instance.scan("GR1")
        checkout_instance.scan("GR1")
        checkout_instance.scan("CF1")
        expect(checkout_instance.total).to be 22.45
      end

      xit "calculates correct discounts for multiple products" do
        # SR1,SR1,GR1,SR1
        checkout_instance.scan("SR1")
        checkout_instance.scan("SR1")
        checkout_instance.scan("GR1")
        checkout_instance.scan("SR1")
        expect(checkout_instance.total).to be 16.61
      end

      xit "calculates correct discounts for mixed products" do
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
