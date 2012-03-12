#include "cracke.hpp"
#include "cracke_ruby.hpp"

RUBY_GLOBAL_SETUP

int cracke_rb_status = true;
bool cracke_rb_started = false;

int cracke_rb_check_status()
{
  if (cracke_rb_status) {
    VALUE rbError = rb_funcall(rb_gv_get("$!"), rb_intern("message"), 0);
    shout((char *) rbError);
  }
  return cracke_rb_status;
}

int cracke_rb_eval(const char *command)
{
  rb_eval_string_protect(command, &cracke_rb_status);
  return cracke_rb_check_status();
}

int cracke_rb_start_interpret(void)
{
  RUBY_INIT_STACK
  ruby_init();
  ruby_init_loadpath();
  ruby_script(RB_INIT_FILENAME);
  cracke_rb_eval("$: << './cracke/src/ruby'");
  rb_load_protect(rb_str_new2(RB_INIT_FILENAME), 0, &cracke_rb_status);
  cracke_rb_check_status();
  cracke_rb_started = true;
  shout("Ruby initialized");
  return cracke_rb_started;
}

int cracke_rb_hook() {

  if (!cracke_rb_started) {
    cracke_rb_start_interpret();
  }
  
  rb_eval_string_protect("loader_loop", &cracke_rb_status);
  cracke_rb_check_status();
  return 0;
}

