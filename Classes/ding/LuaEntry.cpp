#include "LuaEntry.h"

#define SOL_IMGUI_IMPLEMENTATION
#include "ImGuiExt/sol_imgui.h"
#include "ding/sol_cocos.h"

#include "svg/SvgSprite.h"
#include "ImGuiExt/CCIMGUI.h"
#include "lua.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "cmdline.h"
#endif

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

namespace dan {

    LuaEntry::LuaEntry(){}
    LuaEntry::~LuaEntry(){}

    bool LuaEntry::entry()
    {
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
        lua_thirdmodule_register(luaView);
//        std::string entry("res/main.lua");
//        _luaState.script_file(FileUtils::getInstance()->fullPathForFilename(entry));
        return true;
    }

    void LuaEntry::lua_thirdmodule_register(sol::state_view &lua){
        sol::table d = lua.create_table("d");
        d.new_usertype<SVGSprite>("SVGSprite",
                                  "create", &SVGSprite::create
                                  );
    }

    //---------------------------------
    //dev
    //---------------------------------

    void LuaEntry::test_imgui() {
//        CCIMGUI::getInstance()->addImGUI([=]() {
//                // 1. Show a simple window
//                // Tip: if we don't call ImGui::Begin()/ImGui::End() the widgets appears in a window automatically called "Debug"
//                {
//                    static float f = 0.0f;
//                    ImGui::Text("Hello, world!");
//                    ImGui::SliderFloat("float", &f, 0.0f, 1.0f);
//                    ImGui::ColorEdit3("clear color", (float*)&clear_color);
//                    if (ImGui::Button("Test Window")) show_test_window ^= 1;
//                    if (ImGui::Button("Another Window")) show_another_window ^= 1;
//                    ImGui::Text("Application average %.3f ms/frame (%.1f FPS)", 1000.0f / ImGui::GetIO().Framerate, ImGui::GetIO().Framerate);
//
//                    //
//                    if (CCIMGUI::getInstance()->chineseFont)
//                        ImGui::PushFont(CCIMGUI::getInstance()->chineseFont);
//                    static char buf[32] = "Hello";
//                    ImGui::InputText("str中文ing", buf, IM_ARRAYSIZE(buf));
//                    if (CCIMGUI::getInstance()->chineseFont)
//                        ImGui::PopFont();
//                }
//
//                ImGui::ShowDemoWindow();
//
//                // 4. Can Lua function
//                {
//                    _luaState["ImGuiRenderer"]();
//                }
//                }, "demoid");
    }
    
    void LuaEntry::lua_dev_register(sol::state_view &lua){
        sol::table dev = lua.create_named_table("dev");
//        dev.set_function("test_imgui", [=](){})
    }
}
