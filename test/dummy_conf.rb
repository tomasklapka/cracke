#!/usr/bin/ruby

require './cracke/src/cracke.rb'

cracke_options = {
  :enable_ruby => true,
  :enable_lua => false,
  :name => 'dummy',
  :exec => './dummygame',
  :incdirs => '',
  :libdirs => '',
  :libs => '-lGL',
  :hook => {
    :include => "#include <GL/gl.h>\n",
    :lib  => '/usr/lib/libGL.so',
    :type => 'void',
    :name => 'glClear',
    :args => [
      ['GLbitfield', 'mask']
    ],
    :func => '// hook function body',
  },
}

c = Cracke.new(cracke_options)
c.create_hook
c.create_execfile
