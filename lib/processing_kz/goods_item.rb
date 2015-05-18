module ProcessingKz
  class GoodsItem

    attr_reader :name_of_goods,
                :merchants_goods_id,
                :amount,
                :currency_code

    def initialize(args = {})
      @currency_code = args[:currency_code] || ProcessingKz::Config.currency_code
      @name_of_goods = args[:name_of_goods]
      @merchants_goods_id = args[:merchants_goods_id]
      @amount = args[:amount]
    end
  end
end
