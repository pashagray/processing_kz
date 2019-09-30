require 'savon'

module ProcessingKz
  class StartTransaction
    attr_reader :merchant_id,
                :currency_code,
                :language_code,
                :terminal_id,
                :customer_reference,
                :order_id,
                :description,
                :goods_list,
                :additional_goods_list,
                :billing_address,
                :return_url,
                :purchaser_name,
                :purchaser_email,
                :purchaser_phone,
                :merchant_local_date_time,
                :success,
                :redirect_url,
                :error_description,
                :add_mid

    def initialize(args = {})
      @merchant_id = args[:merchant_id] || Config.merchant_id
      @add_mid = args[:add_mid]
      @currency_code = args[:currency_code] || Config.currency_code
      @language_code = args[:language_code] || Config.language_code
      @terminal_id = args[:terminal_id]
      @order_id = args[:order_id]
      @description = args[:description]
      @purchaser_name = args[:purchaser_name]
      @return_url = args[:return_url]
      @purchaser_email = args[:purchaser_email]
      @purchaser_phone = args[:purchaser_phone]
      @customer_reference = args[:customer_reference]

      self.goods_list = args[:goods_list]
      self.additional_goods_list = args[:additional_goods_list]
      self.merchant_local_date_time = args[:merchant_local_date_time] || Time.now
      request!
    end

    def goods_list=(goods)
      if goods.class == Array
        @goods_list = goods
      else
        @goods_list = [goods]
      end
    end

    def additional_goods_list=(goods)
      if goods.class == Array
        @additional_goods_list = goods
      else
        @additional_goods_list = [goods]
      end
    end

    def merchant_local_date_time=(time)
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

    def additional_total_amount
      total = 0
      if additional_goods_list.any?
        additional_goods_list.each do |good|
          total += good.amount
        end
      end
      total
    end

    def hashed_goods_list
      raise NoGoodsError unless goods_list
      hash = []
      goods_list.each { |good| hash << good.to_hash }
      additional_goods_list.each { |good| hash << good.to_hash } if additional_goods_list.any?
      hash
    end

    def transaction_params
      base_params = {
        merchant_id: merchant_id,
        currency_code: currency_code,
        language_code: language_code,
        order_id: order_id,
        goods_list: hashed_goods_list,
        merchant_local_date_time: merchant_local_date_time,
        return_u_r_l: return_url,
        total_amount: total_amount.to_i
      }

      if additional_total_amount > 0
        base_params.merge!(merchantAdditionalInformationList: [{
          key: 'ADD_MID',
          value: add_mid.to_s
        },
        {
          key: 'ADD_TRANAMOUNT',
          value: additional_total_amount.to_i
        }])
      end

      base_params
    end

    def request!
      client = Savon.client(wsdl: Config.wsdl, soap_version: 2, endpoint: Config.host)
      request = client.call(:start_transaction, message: { 
        transaction: transaction_params
      })
      response(request.body[:start_transaction_response][:return])
    end

    def response(args = {})
      @success = args[:success]
      @redirect_url = args[:redirect_url]
      @error_description = args[:error_description]
      @customer_reference = args[:customer_reference]
    end
  end
end
