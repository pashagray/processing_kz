module ProcessingKz
  class StartTransaction

    attr_reader :merchant_id,
                :currency_code,
                :language_code,
                :terminal_id,
                :customer_reference,
                :order_id,
                :total_amount,
                :description,
                :billing_address,
                :goods_list,
                :return_url,
                :purchaser_name,
                :purchaser_email,
                :purchaser_phone,
                :merchant_local_date_time

    def initialize(args = {})
      @merchant_id = args[:merchant_id] || ProcessingKz::Config.merchant_id
      @currency_code = args[:currency_code] || ProcessingKz::Config.currency_code
      @language_code = args[:language_code] || ProcessingKz::Config.language_code
      @terminal_id = args[:terminal_id]
      @order_id = args[:order_id]
      @description = args[:description]
      @goods_list = args[:goods_list]
      @purchaser_name = args[:purchaser_name]
      @purchaser_email = args[:purchaser_email]
      @purchaser_phone = args[:purchaser_phone]
      @customer_reference = args[:customer_reference]
      self.merchant_local_date_time = args[:merchant_local_date_time] || Time.now
    end

    def merchant_local_date_time=(time)
      raise ArgumentError unless time.class == Time
      @merchant_local_date_time = time.strftime('%d.%m.%Y %H:%M:%S')
    end
  end
end
