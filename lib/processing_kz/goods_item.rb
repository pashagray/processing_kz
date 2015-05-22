module ProcessingKz
  class GoodsItem

    attr_reader :title,
                :good_id,
                :amount,
                :currency_code

    def initialize(args = {})
      @currency_code = args[:currency_code] || Config.currency_code
      @title = args[:title]
      @good_id = args[:good_id]
      @amount = (args[:amount] * 100).to_i
    end

    def merchants_goods_id
      @good_id
    end

    def name_of_goods
      @title
    end

    def to_hash
      { currency_code: @currency_code, name_of_goods: name_of_goods, merchants_goods_id: merchants_goods_id, amount: @amount }
    end
  end
end
