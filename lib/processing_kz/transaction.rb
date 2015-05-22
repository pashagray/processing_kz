module ProcessingKz

  def self.start(*args)
    StartTransaction.new(*args)
  end

  def self.get(*args)
    GetTransaction.new(*args)
  end

  def self.complete(*args)
    CompleteTransaction::Request.new(*args).do
  end

  def self.good(*args)
    ProcessingKz::GoodsItem.new(*args)
  end
end
