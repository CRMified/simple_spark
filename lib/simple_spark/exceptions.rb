module SimpleSpark
  class Error < StandardError; end
  class InvalidConfiguration < Error; end
  class DeliveryException < Error; end
end
