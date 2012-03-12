
def format_results(r, join_string=" ")
  out = []
  unless r.nil?
    if r.kind_of?(Array)
      r.each do |m|
        out << "0x%08x" % m
      end
    else
      out << "0x%08x" % r
    end
  end
  return out.join(join_string)
end

