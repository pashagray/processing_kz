require 'spec_helper'

describe ProcessingKz do

  it 'sets and returns merchant_id properly' do
    ProcessingKz.config do |config|
      config.merchant_id = '333000000000000'
    end
    expect(ProcessingKz::Config.merchant_id).to eq('333000000000000')
  end

  it 'sets and returns language_code properly' do
    ProcessingKz.config do |config|
      config.language_code = 'ru'
    end
    expect(ProcessingKz::Config.language_code).to eq('ru')
  end

  it 'restricts to set unsupported languages' do
    expect do
      ProcessingKz.config do |config|
        config.language_code = 'de'
      end
    end.to raise_error(UnsupportedLanguageError)
  end

  it 'sets and returns currency_ocde properly' do
    ProcessingKz.config do |config|
      config.currency_code = '398'
    end
    expect(ProcessingKz::Config.currency_code).to eq('398')
  end
end