puts "loader.rb loading..."

$mainfile = 'main.rb'
$mtime = File.mtime('./cracke/src/ruby/'+$mainfile);
puts "main.rb loading..."
load $mainfile
puts "main.rb loaded"

def check_mainfile()
  if File.mtime($mainfile) != $mtime
    $mtime = File.mtime($mainfile)
    load $mainfile
  end
  return $mtime
end

def loader_loop
  check_mainfile
  begin
    main
  rescue
    puts $!
  end
end

puts "loader.rb loaded"
