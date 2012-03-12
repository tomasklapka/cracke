puts "loader.rb loading..."

$mainfile = 'main.rb'
$mainfile_path = './cracke/src/ruby/'+$mainfile
$mtime = File.mtime($mainfile_path);
puts "main.rb loading..."
load $mainfile
puts "main.rb loaded"

def check_mainfile
  if File.mtime($mainfile_path) != $mtime
    $mtime = File.mtime($mainfile_path)
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
