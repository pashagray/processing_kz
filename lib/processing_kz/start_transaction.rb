require 'savon'

module ProcessingKz
  module StartTransaction
    class Request
      attr_reader :merchant_id,
                  :currency_code,
                  :language_code,
                  :terminal_id,
                  :customer_reference,
                  :order_id,
                  :description,
                  :billing_address,
                  :goods_list,
                  :return_url,
                  :purchaser_name,
                  :purchaser_email,
                  :purchaser_phone,
                  :merchant_local_date_time

      def initialize(args = {})
        @merchant_id = args[:merchant_id] || Config.merchant_id
        @currency_code = args[:currency_code] || Config.currency_code
        @language_code = args[:language_code] || Config.language_code
        @terminal_id = args[:terminal_id]
        @order_id = args[:order_id]
        @description = args[:description]
        @goods_list = args[:goods_list]
        @purchaser_name = args[:purchaser_name]
        @return_url = args[:return_url]
        @purchaser_email = args[:purchaser_email]
        @purchaser_phone = args[:purchaser_phone]
        @customer_reference = args[:customer_reference]
        self.merchant_local_date_time = args[:merchant_local_date_time] || Time.now
      end

      def merchant_local_date_time=(time)
        raise ArgumentError unless time.class == Time
        @merchant_local_date_time = time.strftime('%d.%m.%Y %H:%M:%S')
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

      def do
        client = Savon.client(wsdl: Config.wsdl, endpoint: Config.host)
        response = client.call(:start_transaction, message: { 
          transaction: {
            merchant_id: merchant_id,
            currency_code: currency_code,
            language_code: language_code,
            order_id: order_id,
            goods_list: hashed_goods_list,
            merchant_local_date_time: merchant_local_date_time,
            return_u_r_l: return_url,
            total_amount: total_amount.to_i
            }
          }
        )
        Response.new(response.body[:start_transaction_response][:return])
      end
    end

    class Response
      attr_reader :success,
                  :redirect_url,
                  :error_description,
                  :customer_reference

      def initialize(response)
        @success = response[:success]
        @redirect_url = response[:redirect_url]
        @error_description = response[:error_description]
        @customer_reference = response[:customer_reference]
      end
    end
  end
end
