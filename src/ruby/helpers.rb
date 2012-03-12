
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

