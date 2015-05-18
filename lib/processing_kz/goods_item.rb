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
      @amount = (args[:amount] * 100).to_i
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@").camel_case_lower] = instance_variable_get(var) }
      hash
    end
  end
end
