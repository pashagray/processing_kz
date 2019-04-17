require 'spec_helper'

feature 'Transaction' do

  before do

    ProcessingKz.config do |config|
      config.wsdl = 'spec/CNPMerchantWebService_test.wsdl'
      config.host = 'https://test.processing.kz/CNPMerchantWebServices/services/CNPMerchantWebService'
      config.merchant_id = '333000000000000'
      config.language_code = 'en'
      config.currency_code = 398
    end

    @goods = []
    @goods << ProcessingKz::GoodsItem.new(title: 'Cool stuff', good_id: 124, amount: 1200.00)
    @goods << ProcessingKz::GoodsItem.new(title: 'Mega stuff', good_id: 125, amount: 120.99)

    @good = ProcessingKz::GoodsItem.new(title: 'One stuff', good_id: 125, amount: 12070)
  end

  it 'handles total amount correctly (*100)' do
    request = ProcessingKz::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    expect(request.total_amount).to eq(132099)
  end

  it 'makes a successful start transaction request' do
    request = ProcessingKz::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    expect(request.success).to eq(true)
  end

  it 'makes a unsuccessful star transaction request' do
    request = ProcessingKz::StartTransaction.new(merchant_id: 'bad_id', goods_list: @goods)
    expect(request.success).to eq(false)
  end

  it 'makes request for transaction status which is pending' do
    request = ProcessingKz::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    status = ProcessingKz::GetTransaction.new(customer_reference: request.customer_reference)
    expect(status.transaction_status).to eq('PENDING_CUSTOMER_INPUT')
  end

  it 'makes request for transaction status which is authorised' do
    request = ProcessingKz::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://google.com')
    visit request.redirect_url
    fill_in 'pan', with: '4012 0010 3844 3335'
    select  '01', from: 'expiryMonth'
    select  '2021', from: 'expiryYear'
    fill_in 'cardHolder', with: 'IVAN INAVOV'
    fill_in 'cardSecurityCode', with: '123'
    fill_in 'cardHolderEmail', with: 'test@processing.kz'
    fill_in 'cardHolderPhone', with: '87771234567'
    click_button 'Pay'
    sleep 20
    status = ProcessingKz::GetTransaction.new(customer_reference: request.customer_reference)
    expect(status.transaction_status).to eq('PAID')
    click_button 'Return'
  end

  it 'successfuly makes all process of transaction through coder friendly interface' do
    start = ProcessingKz.start(order_id: rand(1..1000000), goods_list: @good, return_url: 'http://google.com')
    visit start.redirect_url
    fill_in 'pan', with: '4012 0010 3844 3335'
    select  '01', from: 'expiryMonth'
    select  '2021', from: 'expiryYear'
    fill_in 'cardHolder', with: 'MARIA SIDOROVA'
    fill_in 'cardSecurityCode', with: '123'
    fill_in 'cardHolderEmail', with: 'test@processing.kz'
    fill_in 'cardHolderPhone', with: '87011234567'
    click_button 'Pay'
    sleep 5
    ProcessingKz.complete(customer_reference: start.customer_reference, transaction_success: true)
    status = ProcessingKz.get(customer_reference: start.customer_reference)
    expect(status.transaction_status).to eq('PAID')
    click_button 'Return'
  end

  # it 'successfuly declines payment process of transaction through coder friendly interface' do
  #   start = ProcessingKz.start(order_id: rand(1..1000000), goods_list: @good, return_url: 'http://google.com')
  #   visit start.redirect_url
  #   fill_in 'pan', with: '4012 0010 3844 3335'
  #   select  '01', from: 'expiryMonth'
  #   select  '2021', from: 'expiryYear'
  #   fill_in 'cardHolder', with: 'MARIA SIDOROVA'
  #   fill_in 'cardSecurityCode', with: '123'
  #   fill_in 'cardHolderEmail', with: 'test@processing.kz'
  #   fill_in 'cardHolderPhone', with: '87011234567'
  #   click_button 'Pay'
  #   sleep 20
  #   ProcessingKz.complete(customer_reference: start.customer_reference, transaction_success: false)
  #   status = ProcessingKz.get(customer_reference: start.customer_reference)
  #   expect(status.transaction_status).to eq('REVERSED')
  #   click_button 'Return'
  # end
end
