require 'savon'

module ProcessingKz
  module GetTransaction
    class Request
      attr_reader :merchant_id, :customer_reference

      def initialize(args= {})
        @merchant_id = args[:merchant_id] || Config.merchant_id
        @customer_reference = args[:customer_reference]
      end

      def do
        client = Savon.client(wsdl: Config.wsdl, endpoint: Config.host)
        response = client.call(:get_transaction_status, message: { 
          merchant_id: merchant_id,
          customer_reference: customer_reference
          }
        )
        Response.new(response.body[:get_transaction_status_response][:return])
      end
    end

    class Response
      attr_reader :transaction_status,
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
                  :merchant_online_address

      def initialize(args = {})
        @transaction_status = args[:transaction_status]
        @transaction_currency_code = args[:currency_code] || Config.currency_code
        @amount_requested = args[:amount_requested]
        @amount_authorized = args[:amount_authorized]
        @amount_refunded = args[:amount_refunded]
        goods = args[:goods_list]
        @auth_code = args[:auth_code]
        @purchaser_name = args[:purchaser_name]
        @purchaser_email = args[:purchaser_email]
        @purchaser_phone = args[:purchaser_phone]
        @merchant_online_address = args[:merchant_online_address]
        @merchant_local_date_time = args[:merchant_local_date_time] || Time.now
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
    end
  end
end