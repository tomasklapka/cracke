class Cracke

  attr_reader :options

  def initialize(options)
    @options = options
    @options[:deploydir] = Dir.pwd + "/cracke/"
    init_data
  end

  def create_execfile
    o = @options

    File.
      open("launch_cracke_#{o[:name]}.sh", "w").
      puts(@template_execfile.
        gsub(/@NAME@/, o[:name]).
        gsub(/@LIBRARY_NAME@/, "#{o[:name]}_hook.so").
        gsub(/@DEPLOY_DIR@/, o[:deploydir]).
        gsub(/@EXEC@/, o[:exec]))
        
    %x[chmod +x launch_cracke_#{o[:name]}.sh]
  end

  def create_hook
    o = @options
  
    f = File.open("./cracke/run/#{o[:name]}_hook.cpp", "w")
    f.write(@template_hook.
      gsub(/@HOOK_TYPE@/, o[:hook][:type]).
      gsub(/@HOOK_INCLUDE@/, o[:hook][:include]).
      gsub(/@HOOK_NAME@/, o[:hook][:name]).
      gsub(/@HOOK_LIB@/, o[:hook][:lib]).
      gsub(/@HOOK_ARG_NAMES@/, o[:hook][:args].map { |x| "#{x[0]}" }.join(', ')).
      gsub(/@HOOK_ARG_VALUES@/, o[:hook][:args].map { |x| "#{x[1]}" }.join(', ')).
      gsub(/@HOOK_ARGS@/, o[:hook][:args].map { |x| "#{x[0]} #{x[1]}" }.join(', ')))
    f.close
  
    compile_hook
  end

  def compile_hook
    o = @options
    
    gcc_options = "-std=gnu++0x -fpermissive -fPIC -g -I/usr/local/include -I/usr/include -I./cracke/src -I./cracke/src/ruby -I./cracke/src/lua"

    clear_cmd = "rm -f ./cracke/run/*.o && rm -f ./cracke/run/*.so"
    compile_ruby_cmd = "g++ #{gcc_options} #{o[:incdirs]} " +
                  "-o ./cracke/run/cracke_ruby.o -c ./cracke/src/ruby/cracke_ruby.cpp 2>&1"
    compile_lua_cmd = "g++ #{gcc_options} #{o[:incdirs]} " +
                  "-o ./cracke/run/cracke_lua.o -c ./cracke/src/lua/cracke_lua.cpp 2>&1"
    compile_libs_cmd = compile_ruby_cmd + ' && ' + compile_lua_cmd
    compile_hook_cmd = "g++ #{gcc_options} #{o[:incdirs]} " +
                  "-o ./cracke/run/#{o[:name]}_hook.o -c ./cracke/run/#{o[:name]}_hook.cpp 2>&1"
    link_cmd = "g++ #{gcc_options} -shared -L/usr/local/lib -L./cracke/src/ruby -L./cracke/src/lua #{o[:incdirs]} -ldl -lruby -llua #{o[:libs]} " +
                "-o ./cracke/run/#{o[:name]}_hook.so ./cracke/run/cracke_ruby.o ./cracke/run/cracke_lua.o ./cracke/run/#{o[:name]}_hook.o 2>&1"
    puts %x[#{clear_cmd} && #{compile_libs_cmd} && #{compile_hook_cmd} && #{link_cmd}]
  end

  def init_data
  @template_execfile = <<END
#!/bin/sh
export LD_DEBUG=all
export LD_DEBUG_OUTPUT=@DEPLOY_DIR@run/ld_debug_@NAME@
export LD_LIBRARY_PATH=@DEPLOY_DIR@run:$LD_LIBRARY_PATH
export LD_PRELOAD=@LIBRARY_NAME@
@EXEC@
END

  @template_hook = <<END
#include "cracke.hpp"
#include "ruby/cracke_ruby.hpp"
#include "lua/cracke_lua.hpp"

@HOOK_INCLUDE@

using namespace std;

void shout(const char *message)
{
  fputs(message, stderr);
  fputs("\\n", stderr);
  
  FILE *fp;
  fp=fopen("cracket.log", "a");
  fprintf(fp, "%s\\n", message);
  fclose(fp);
}

int cracke_hook()
{
  cracke_rb_hook();
  cracke_lua_hook();
}

/* Hook function */
@HOOK_TYPE@ @HOOK_NAME@(@HOOK_ARGS@) {
  static @HOOK_TYPE@ (*lib_@HOOK_NAME@)(@HOOK_ARGS@) = NULL;
  void* handle;
  char* errorstr;

  if(!lib_@HOOK_NAME@) {
    handle = dlopen("@HOOK_LIB@", RTLD_LAZY);
    if(!handle) {
      shout("dlopen fail:");
      shout(dlerror());
      exit(1);
    }

    /* Fetch pointer of real glClear() func */
    lib_@HOOK_NAME@ = (@HOOK_TYPE@ (*) (@HOOK_ARG_NAMES@)) dlsym(handle, "@HOOK_NAME@");
    if( (errorstr = dlerror()) != NULL ) {
      shout("dlsym fail:");
      shout(errorstr);
      exit(1);
    }
  }

  /* Woot */
  cracke_hook();

  /* Call real function() */
  return lib_@HOOK_NAME@(@HOOK_ARG_VALUES@);

}
END

  end
  
end
