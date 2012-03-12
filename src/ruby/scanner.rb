require 'dma'

class Scanner
  attr_accessor :ranges, :func
  attr_reader :addresses

  def initialize(ranges, func)
    @ranges = ranges
    @func = func
  end

  def scan_address(value, addr)
    value == @func.call(addr)
  end

  def scan_address_range(value, from_addr, to_addr, size = 4)
    addresses = []
    (from_addr..to_addr).each do |addr|
      if (addr % size == 0)
        addresses << addr if scan_address(value, addr)
      end
    end
    return addresses
  end
  
  def rescan(value)
    addresses = []
    @addresses.each do |addr|
      addresses << addr if scan_address(value, addr)
    end
    addresses
  end
  
  def scan(value, size = 4)
    if @addresses
      addresses = rescan(value)
    else
      addresses = []
      @ranges.each do |range|
        addresses += scan_address_range(value, range[0], range[1], size)
      end
    end
    @addresses = addresses
    return @addresses
  end
  
  def reset()
    @addresses = nil
  end
end
