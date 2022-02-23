#ifndef _LUAENTRY_H_
#define _LUAENTRY_H_

/************************************/
/* lua脚本入口*/
/************************************/
#include <functional>
#include "sol/sol.hpp"

extern "C" {
#include "lua.h"
};

namespace dan{
    
    class LuaEntry
    {
    public:
        LuaEntry();
        
        ~LuaEntry();
        /**
         lua启动入口
         */
        bool entry();
    protected:
        /**
        注册三方扩展
        @param lua sol::state_view
        **/
        void lua_thirdmodule_register(sol::state_view& lua);
        
        /**
         注册调试用lua接口
         @param lua sol::state_view
         */
        void lua_dev_register(sol::state_view& lua);
        void test_imgui();
        
        sol::state _luaState;
    };
}
#endif // !_LUAENTRY_H_
