require 'spec_helper'

describe ProcessingKz::StartTransaction do

  before do

    ProcessingKz.config do |config|
      config.client = 'https://test.processing.kz/CNPMerchantWebServices/CNPMerchantWebService.wsdl'
      config.host = 'https://test.processing.kz/CNPMerchantWebServices/services/CNPMerchantWebService'
      config.merchant_id = '333000000000000'
      config.language_code = 'ru'
      config.currency_code = 398
    end

    @goods = []
    @goods << ProcessingKz::GoodsItem.new(name_of_goods: 'Cool stuff', merchants_goods_id: 124, amount: 1200.00)
    @goods << ProcessingKz::GoodsItem.new(name_of_goods: 'Mega stuff', merchants_goods_id: 125, amount: 120.99)
  end

  it 'handles total amount correctly (*100)' do
    request = ProcessingKz::StartTransaction::Request.new(order_id: 1, goods_list: @goods, return_url: 'http://localhost')
    expect(request.total_amount).to eq(132099)
  end

  it 'makes a successful request' do
    request = ProcessingKz::StartTransaction::Request.new(order_id: 1, goods_list: @goods, return_url: 'http://ya.ru')
    expect(request.do.success).to eq(true)
  end

  it 'makes a unsuccessful request' do
    request = ProcessingKz::StartTransaction::Request.new(merchant_id: 'bad_id', goods_list: @goods)
    expect(request.do.success).to eq(false)
  end
end