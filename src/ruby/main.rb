puts "-------------------" 
puts "cracket_main loaded"
puts "-------------------"

require 'dma'

=begin

def format_results r
  unless r.nil?
    if r.kind_of?(Array)
      r.each do |m|
        puts "0x%08x" % m
      end
    else
      puts "0x%08x" % r
    end
  end
end
=end

$i=0

def main

    $i+=1
    p $i

  $dma = Dma.new unless $dma
  p $dma.data
#  format_results 
#  p $dma.read_uint(0x7fff8de9c350)

end
