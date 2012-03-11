#include "cracke.hpp"
#include "cracke_lua.hpp"

bool cracke_lua_started = false;
lua_State *cracke_lua_State = NULL;


int cracke_lua_eval(const char *command) {
  return luaL_dostring(cracke_lua_State, command);
}

static void cracke_lua_openlibs(const luaL_reg *lualibs) {
  const luaL_reg *lib;

  for (lib = lualibs; lib->func != NULL; lib++)
  {
     lib->func(cracke_lua_State);
     lua_settop(cracke_lua_State, 0);
  }
}
 
int cracke_lua_start_interpret(void)
{
  static const luaL_reg cracke_lualibs[] =
  {
    { "base",       luaopen_base },
    { NULL,         NULL }
  };

  cracke_lua_State = luaL_newstate();
  cracke_lua_openlibs(cracke_lualibs);
  luaL_dofile(cracke_lua_State, LUA_INIT_FILENAME);
  cracke_lua_started = true;
  shout("Lua initialized");
  return cracke_lua_started;
}

int cracke_lua_hook() {

  if (!cracke_lua_started) {
    cracke_lua_start_interpret();
  }
  
  cracke_lua_eval("loop()");
  return 0;
}

