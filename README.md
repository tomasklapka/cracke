## Usage

- make and install dma library from lib/dma (copy dma.so and dma.rb to your ruby libs system directory)

- copy cracke to your game's working directory or create a symlink there

- create your own conf.rb file (example: https://github.com/tomasklapka/cracke/blob/master/test/dummy_conf.rb)

- run conf file

- run launcher launch_cracke_NAME.sh

If you enable Ruby main function is called by hook from https://github.com/tomasklapka/cracke/blob/master/src/ruby/main.rb
You can edit the file and hook reloads it dynamically when it is modified.

Lua is just embedded and there is no Lua code yet
