require 'dma.so'

class Dma

  attr_reader :data, :stack, :heap

  def initialize
    memmap
  end

  def read_uint(address)
    return nil unless is_address_safe?(address)
    _read_uint(address)
  end

  def read_ulong(address)
    return nil unless is_address_safe?(address)
    _read_ulong(address)
  end

  def read_float(address)
    return nil unless is_address_safe?(address)
    _read_float(address)
  end

  def is_address_safe?(address)
    [@data, @stack, @heap].each do |range|
      if range
        if range[0].kind_of?(Array)
          range.each do |subrange|
            return true if is_in_range?(address, subrange)
          end
        else
          return true if is_in_range?(address, range)
        end
      end
    end
    false
  end

  def ranges
    ranges = []
    ranges << @heap if @heap
    ranges << @stack if @stack
    @data.each { |range| ranges << range }
    ranges
  end

  private

  def is_in_range?(address, range)
    return true if (range[0] <= address) and (address <= (range[1] - 8))
    false
  end

  # memmap method is based on https://github.com/rikiji/ruby-memscan/blob/master/memscan.rb
  # by Riccardo Cecolin <rikiji@playkanji.com>
  def memmap
    pid = $$
    f= File.open "/proc/#{pid}/cmdline"
    cmd= f.read.split "\0"    
    f= File.open "/proc/#{pid}/maps"

    stack = heap = nil
    data = Array.new
    f.each_line do |line|
      data << line.split(' ').first.split('-') if line.match cmd.first
      stack = line.split(' ').first.split('-') if line.match "stack"
      heap = line.split(' ').first.split('-') if line.match "heap"
    end

    unless data.empty?
      @data= data.map do |a|
        a= a.map do |e|
          e.to_i(16)
        end
      end
    end

    unless stack.nil?
      @stack= stack.map do |e|
        e.to_i(16)
      end
    end

    unless heap.nil?
      @heap= heap.map do |e|
        e.to_i(16)
      end
    end

  end

end
