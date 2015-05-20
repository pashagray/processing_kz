require 'spec_helper'

describe 'Transaction' do

  before do

    ProcessingKz.config do |config|
      config.wsdl = 'https://test.processing.kz/CNPMerchantWebServices/CNPMerchantWebService.wsdl'
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
    request = ProcessingKz::StartTransaction::Request.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    expect(request.total_amount).to eq(132099)
  end

  it 'makes a successful start transaction request' do
    request = ProcessingKz::StartTransaction::Request.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    expect(request.do.success).to eq(true)
  end

  it 'makes a unsuccessful star transaction request' do
    request = ProcessingKz::StartTransaction::Request.new(merchant_id: 'bad_id', goods_list: @goods)
    expect(request.do.success).to eq(false)
  end

  it 'makes request for transaction status which is pending' do
    request = ProcessingKz::StartTransaction::Request.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    status = ProcessingKz::GetTransaction::Request.new(customer_reference: request.do.customer_reference)
    expect(status.do.transaction_status).to eq('PENDING_CUSTOMER_INPUT')
  end

  it 'makes request for transaction status which is paid' do
    request = ProcessingKz::StartTransaction::Request.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    status = ProcessingKz::GetTransaction::Request.new(customer_reference: request.do.customer_reference)
    expect(status.do.transaction_status).to eq('PENDING_CUSTOMER_INPUT')
  end
end