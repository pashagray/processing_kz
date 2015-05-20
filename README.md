# ProcessingKz

Integrate Ruby projects with Processing.kz without pain. Current version supports only standard payments without refunding. Please watch project for new releases.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'processing_kz'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install processing_kz

If you are using Rails 3+, please initiate configuration file by running

    rake processing_kz:install

We will generate configuration file for you in `config/initializers`. You have to set all credentials received from Processing.kz provider.

    ProcessingKz.config do |config|
      config.wsdl = 'wsdl address'
      config.host = 'processing_kz server address'
      config.merchant_id = 'your merhant id'
      config.language_code = 'ru' # ru, en or kz
      config.currency_code = 398 # KZT code
    end

If you are not using Rails, include this configuration in appropriate place, so processing_kz gem can obtain all neccesary information.

## Usage

Full transaction process includes 3 steps. First you need to initiate transaction process and provide 

    start = ProcessingKz.start(order_id: 1, goods_list: @goods, return_url: 'page for customer to continiue after payment')

Next step is to check that money is successfuly blocked on customer's card. Just pass customer_reference obtained from previous method.
  
    status = ProcessingKz.get(customer_reference: start.customer_reference)

Finaly you need to complete transaction to withdraw money from card. Again just pass customer_reference which you obtained during starting transaction.
  
    ProcessingKz.complete(customer_reference: start.customer_reference)


## Contributing

1. Fork it ( https://github.com/paveltkachenko/processing_kz/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
