module ProcessingKz
  
  def self.start(*args)
    StartTransaction::Request.new(*args).do
  end

  def self.get(*args)
    GetTransaction::Request.new(*args).do
  end

  def self.complete(*args)
    CompleteTransaction::Request.new(*args).do
  end

  def self.good(*args)
    ProcessingKz::GoodsItem.new(*args)
  end
end
