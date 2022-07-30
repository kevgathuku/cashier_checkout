# Cashier

[![Build Status](https://app.travis-ci.com/kevgathuku/cashier_checkout.svg?branch=main)](https://app.travis-ci.com/kevgathuku/cashier_checkout)

A cashier module that calculates the prices of a user's cart items,
taking different discount rules into account

The rules take this format:

```
{
      "PRODUCT_CODE" => { price: Float,
                         name: String,
                         discount_threshold: Integer,
                         discount_calc: Proc | discount_price: int
    }
```

| Attribute            | Meaning                                                                                             |
| -------------------- | --------------------------------------------------------------------------------------------------- |
| `price`              | The regular price applied in case of no discount                                                    |
| `name`               | Human-readable product name                                                                         |
| `discount_threshold` | The number of items required for the discount to be applied                                         |
| `discount_calc`      | A proc taking 2 arguments: price and quantity, to calculates the discount based on a custom formula |

The rules (with discounts) can be specified in 2 formats:

1. Add `discount_price` and `discount_threshold` attributes

When the total for the cart items is being calculated, if the number of items is equal to or exceeds the `discount_threshold`, then the `discount_price` will be used instead of the regular `price`

For example this rule specifies that for 3 or more Pens, the discounted price for each will be `5.5` instead of `6`

```ruby
{
  'P1' => {
    price: 6,
    name: 'Pens',
    discount_threshold: 3,
    discount_price: 5.5,
  },
}
```

2. Add a `discount_price` and `discount_calc` attributes

When the total for the cart items is being calculated, if the number of items is equal to or exceeds the `discount_threshold`, then the `discount_calc` will be run to calculate the total for the item.

For example this rule will apply a discount of 30% to each pen, if the user purchases 3 or more pens.

```ruby
{
  'P1' => {
    price: 6,
    name: 'Pens',
    discount_threshold: 3,
    discount_calc: Proc.new { |price, qty|
      price * 0.3 * qty
    },
  },
}

```

## Usage

Clone this repository

    $ git clone https://github.com/kevgathuku/cashier_checkout.git

Install the dependencies:

    $ bundle install

Run the tests:

    $ rspec

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kevgathuku/cashier.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
