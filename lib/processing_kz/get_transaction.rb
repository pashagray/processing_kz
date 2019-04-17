require 'savon'

module ProcessingKz
  class GetTransaction

    attr_reader :merchant_id, 
                :customer_reference,
                :transaction_status,
                :transaction_currency_code,
                :amount_requested,
                :amount_authorized,
                :amount_refunded,
                :goods,
                :auth_code,
                :purchaser_name,
                :purchaser_email,
                :purchaser_phone,
                :merchant_local_date_time,
                :merchant_online_address,
                :additional_information

    def initialize(args= {})
      @merchant_id = args[:merchant_id] || Config.merchant_id
      @customer_reference = args[:customer_reference]
      request!
    end

    def status
      @transaction_status
    end

    def goods=(goods)
      @goods = goods if goods.class == Array
      @goods = [goods] unless goods.class == Array
    end

    def total_amount
      raise NoGoodsError unless goods_list
      total = 0
      goods_list.each do |good|
        total += good.amount
      end
      total
    end

    def hashed_goods_list
      hash = []
      goods_list.each do |good|
        hash << good.to_hash
      end
      hash
    end

    def request!
      client = Savon.client(wsdl: Config.wsdl, endpoint: Config.host)
      response = client.call(:get_transaction_status, message: { 
        merchant_id: merchant_id,
        reference_nr: customer_reference
        }
      )
      response(response.body[:get_transaction_status_response][:return])
    end

    def response(args = {})
      @transaction_status = args[:transaction_status]
      @transaction_currency_code = args[:currency_code] || Config.currency_code
      @amount_requested = args[:amount_requested]
      @amount_authorized = args[:amount_authorized]
      @amount_refunded = args[:amount_refunded]
      @auth_code = args[:auth_code]
      @purchaser_name = args[:purchaser_name]
      @purchaser_email = args[:purchaser_email]
      @purchaser_phone = args[:purchaser_phone]
      @merchant_online_address = args[:merchant_online_address]
      @merchant_local_date_time = args[:merchant_local_date_time] || Time.now
      @additional_information = args[:additional_information]
      self.goods = args[:goods_list]
    end
  end
end