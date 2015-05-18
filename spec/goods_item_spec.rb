require 'spec_helper'

describe ProcessingKz::GoodsItem do

  it 'creates goods item' do
    goods_item = ProcessingKz::GoodsItem.new(name_of_goods: 'Cool stuff', merchants_goods_id: 124, amount: 1200.0)
    expect(goods_item.name_of_goods).to eq('Cool stuff')
  end
end