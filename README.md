# ProcessingKz

<img src="https://badge.fury.io/rb/processing_kz.svg" data-bindattr-39="39" class="retina-badge">

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

If you are using Rails 3+, please initiate configuration file by running:

    rails g processing_kz:config

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

Full transaction process includes 3 steps. First you need to initiate transaction process and provide at least order_id, list of goods (see additional info below) and return url.

    start = ProcessingKz.start(order_id: 1, goods_list: @goods, return_url: 'page for customer to continiue after payment')

Next step is to check that money is successfuly blocked on customer's card. Just pass customer_reference obtained from previous method.
  
    transaction = ProcessingKz.get(customer_reference: start.customer_reference)
    transaction.status #=> 'AUTHORISED'

Finaly you need to complete transaction to withdraw money from card. Again just pass customer_reference which you obtained during starting transaction.
  
    ProcessingKz.complete(customer_reference: start.customer_reference)

Check that everything is alright. You have to get `'PAID'` status.
    
    transaction = ProcessingKz.get(customer_reference: start.customer_reference)
    transaction.status #=> 'PAID'

### List of Goods
  
ProcessingKz is requiring list of goods or services for transaction. You can pass one good or array of goods in transaction. 
    
    my_good = ProcessingKz.good(title: 'Title of good', amount 1200.99)
    start = ProcessingKz.start(order_id: 1, goods_list: my_good, return_url: 'page for customer to continiue after payment')

### Return URL
  
After finishing paying process in Processing.kz frame, user will be redirected to URL, which you defined in return_url. This will help you to continiue process on your site after successful payment.


## Contributing

1. Fork it ( https://github.com/paveltkachenko/processing_kz/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
