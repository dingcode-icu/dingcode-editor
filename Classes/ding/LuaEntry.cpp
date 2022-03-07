#include <string>
#include <inttypes.h>
#include "LuaEntry.h"
#define SOL_IMGUI_IMPLEMENTATION

#include "ImGuiExt/sol_imgui.h"
#include "ding/sol_cocos.h"

#include "svg/SvgSprite.h"
#include "lua.h"
#include "ImGuiExt/CCImGuiLayer.h"
#include "ImGuiExt/CCIMGUI.h"
#include "ding/FileDialogUtils.h"
#include "ding/guid/guid.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "cmdline.h"
#endif

using namespace std;
USING_NS_CC;


/// <summary>
/// Lua print
/// </summary>
#define MAX_LOG_LENGTH 16 * 1024
void print_win32(const std::string& str)
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32
    wchar_t buf[MAX_LOG_LENGTH] = { '\0' };
    size_t i = 0;
    for (i = 0; i < str.length(); i++)
    {
        buf[i] = str.c_str()[i];
    }
    buf[i] = '\n';
    OutputDebugString(buf);
#endif
}

int lua_print(lua_State* L)
{
    int n = lua_gettop(L);  /* number of arguments */
    int i;

    std::string out;
    lua_getglobal(L, "tostring");
    for (i = 1; i <= n; i++) {
        const char* s;
        lua_pushvalue(L, -1);  /* function to be called */
        lua_pushvalue(L, i);   /* value to print */
        lua_call(L, 1, 1);
        size_t sz;
        s = lua_tolstring(L, -1, &sz);  /* get result */
        if (s == NULL)
            return luaL_error(L, LUA_QL("tostring") " must return a string to "
                LUA_QL("print"));
        if (i > 1) out.append("\t");
        out.append(s, sz);
        lua_pop(L, 1);  /* pop result */
    }

    print_win32(out);

    cocos2d::log("[LUA-PRINT] %s\n \n", out.c_str());
    fflush(stdout);
    return 0;
}

const char* new_guid(){
    int len = 64;
    char *ret = new char[len];
    ding::Guid guid = ding::guid::new_guid();
    return ding::guid::to_string(ret, len, guid);
}

namespace dan {

    LuaEntry::LuaEntry(){}
    LuaEntry::~LuaEntry(){}

    bool LuaEntry::entry()
    {
#if CC_TARGET_PLATFORM == CC_PLATFORM_MAC
        FileUtils::getInstance()->setDefaultResourceRootPath("res");
#endif
        ding::guid_globals::init();
        //base 
        _luaState.open_libraries();
        _luaState["print"] = [&]() {
            lua_State* L = _luaState.lua_state();
            lua_print(L);
        };
        _luaState["ImGuiRenderer"] = []() { };
        sol::state_view luaView(_luaState.lua_state());
        //imgui
        sol_ImGui::Init(luaView);
        //cocos
        sol_cocos2d::Init(luaView);
        //third
        lua_third_register(luaView);
        //load res/main.lua

        auto def = FileUtils::getInstance()->getDefaultResourceRootPath();
        std::string name("main.lua");
        auto path = FileUtils::getInstance()->fullPathForFilename(name);
        auto workspace = path;
        workspace.replace(path.find(name), name.size(), "");
        FileUtils::getInstance()->setDefaultResourceRootPath(workspace);

        char l_append[512];
        sprintf(l_append,"package.path = package.path..';%s?.lua;'", workspace.c_str());
        _luaState.script(l_append);
        _luaState.script_file(path);

        imgui_render();
        ImGuiLayer::createAndKeepOnTop();
        return true;
    }

    void LuaEntry::lua_third_register(sol::state_view &lua){
        sol::table d = lua.create_table("ding");
        d.set_function("guid", new_guid);
        d.new_usertype<SVGSprite>("SVGSprite",
                                  "create", &SVGSprite::create
                                  );
        d.new_usertype<FileDialogUtils>("FileDialogUtils", "GetSaveFile", &FileDialogUtils::GetSaveFile,
                                        "GetOpenFile", &FileDialogUtils::GetOpenFile);
    }

    //---------------------------------
    //dev
    //---------------------------------

    void LuaEntry::imgui_render() {
        CCIMGUI::getInstance()->addImGUI([=]() {
                ImGui::ShowDemoWindow();
                // 4. Can Lua function
                if (CCIMGUI::getInstance()->chineseFont)
                    ImGui::PushFont(CCIMGUI::getInstance()->chineseFont);
                {
                    _luaState["ImGuiRenderer"]();
                }
                if (CCIMGUI::getInstance()->chineseFont)
                    ImGui::PopFont();
                }, "demoid");
    }
    
    void LuaEntry::lua_dev_register(sol::state_view &lua){
        sol::table dev = lua.create_named_table("dev");
//        dev.set_function("imgui_render", [=](){})
    }
}
