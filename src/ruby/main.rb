puts "-------------------" 
puts "cracket_main loaded"
puts "-------------------"

require 'dma'

load 'helpers.rb'
load 'scanner.rb'

def main
  $counter = 0 unless $counter
  $counter += 1
  $dma = Dma.new unless $dma
  $scanner = Scanner.new($dma.ranges, lambda do |a| 
    $dma.read_uint(a)
  end) unless $scanner

  if $counter == 1
    $scanner.reset
    $scanner.scan(0)
  end
  if $counter == 11
    $scanner.scan(1)
  end
  if $counter == 21
    $scanner.scan(2)
    puts $scanner.addresses.map { |a| format_results(a) }
  end
  if $counter == 31
    $scanner.scan(3)
    puts $scanner.addresses.map { |a| format_results(a) }
  end
  if ($counter > 31 and ($counter-1) % 10 == 0)
    $scanner.addresses.map { |a| puts "Dead players: #{$dma.read_uint(a)} at #{format_results(a)} found by embedded ruby" }
  end
end

