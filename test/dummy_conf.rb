#!/usr/bin/ruby

require './cracke/src/cracke.rb'

cracke_options = {
  :deploy_dir => './dummy_deploy/',
  :name => 'dummy',
  :exec => './dummygame',
  :incdirs => '-I/usr/include -I/usr/include/ruby-1.9.1 -I/usr/include/ruby-1.9.1/ruby/backward -I/usr/include/ruby-1.9.1/x86_64-linux -I/usr/include/ruby-1.9.1/i686-linux',
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
  },
}

c = Cracke.new(cracke_options)
c.create_hook
c.create_execfile
