module ProcessingKz

  def self.config(&block)
    instance_eval(&block)
  end

  def self.merchant_id=(merchant_id)
    @@merchant_id = merchant_id
  end

  def self.merchant_id
    @@merchant_id
  end

  def self.currency_code=(currency_code)
    @@currency_code = currency_code
  end

  def self.currency_code
    @@currency_code
  end

  def self.language_code=(language_code)
    raise ArgumentError unless ['ru', 'en', 'kz'].include?(language_code)
    @@language_code = language_code
  end

  def self.language_code
    @@language_code
  end
end
