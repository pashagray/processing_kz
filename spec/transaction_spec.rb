require 'spec_helper'

feature 'Transaction' do

  before do

    ProcessingKz.config do |config|
      config.wsdl = 'https://test.processing.kz/CNPMerchantWebServices/CNPMerchantWebService.wsdl'
      config.host = 'https://test.processing.kz/CNPMerchantWebServices/services/CNPMerchantWebService'
      config.merchant_id = '333000000000000'
      config.language_code = 'en'
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
    request = ProcessingKz::StartTransaction::Request.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://google.com')
    response = request.do
    visit response.redirect_url
    expect(page).to have_content(request.order_id)
    fill_in 'panPart1', with: '4012'
    fill_in 'panPart2', with: '0010'
    fill_in 'panPart3', with: '3844'
    fill_in 'panPart4', with: '3335'
    select  '01', from: 'expiryMonth'
    select  '2029', from: 'expiryYear'
    fill_in 'cardHolder', with: 'IVAN INAVOV'
    fill_in 'cardSecurityCode', with: '123'
    fill_in 'cardHolderEmail', with: 'test@processing.kz'
    fill_in 'cardHolderPhone', with: '87771234567'
    click_button 'Pay'
    sleep 5
    status = ProcessingKz::GetTransaction::Request.new(customer_reference: response.customer_reference)
    expect(status.do.transaction_status).to eq('AUTHORISED')
  end
end