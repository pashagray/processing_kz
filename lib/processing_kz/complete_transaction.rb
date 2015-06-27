require 'savon'

module ProcessingKz
  class CompleteTransaction
    attr_reader :merchant_id, 
                :customer_reference,
                :transaction_success,
                :override_amount,
                :goods_list,
                :success

    def initialize(args= {})
      @merchant_id = args[:merchant_id] || Config.merchant_id
      @customer_reference = args[:customer_reference]
      @transaction_success = args[:transaction_success]
      @override_amount = args[:override_amount]
      @goods_list = args[:goods_list]
      request!
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
      response = client.call(:complete_transaction, message: { 
        merchant_id: merchant_id,
        reference_nr: customer_reference,
        transaction_success: transaction_success,
        override_amount: override_amount,
        goods_list: goods_list
        }
      )
      response(response.body[:complete_transaction_response][:return])
    end

    def response(success)
      @success = success
    end
  end
end