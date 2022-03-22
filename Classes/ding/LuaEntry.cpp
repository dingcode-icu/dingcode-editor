#include "LuaEntry.h"
#include "ding/Core.h"

#include "lua.h"
#include "ding/common/StringUtil.h"
#include "ImGuiExt/sol_imgui.h"
#include "ding/sol_cocos.h"
#include "svg/SvgSprite.h"
#include "ImGuiExt/CCImGuiLayer.h"
#include "ImGuiExt/CCIMGUI.h"
#include "ding/sys/FileDialogUtils.h"
#include "ding/guid/guid.h"

using namespace std;
USING_NS_CC;


/*
 * lua print打印复写
 * */
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
    cocos2d::log("[LUA-PRINT] %s\n \n", out.c_str());
    fflush(stdout);
    return 0;
}

/*
 *创新新的guid
 * */
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
        //imgui+cocos init
        sol_ImGui::Init(luaView);
        sol_cocos2d::Init(luaView);
        //third bind
        lua_third_register(luaView);
        lua_dev_register(luaView);
        //load res/main.lua
        auto def = FileUtils::getInstance()->getDefaultResourceRootPath();
        std::string name("main.lua");
        std::string workspace("");
        auto path = FileUtils::getInstance()->fullPathForFilename(name);
        workspace = path;
        workspace.replace(path.find(name), name.size(), "");
        FileUtils::getInstance()->setDefaultResourceRootPath(workspace);

        std::string cmd("package.path = package.path..';{l}/?.lua;{l}/res/?.lua;{l}/?/init.lua;{l}/res/?/init.lua;'");
        _luaState.script(StringUtil::Replace(cmd, "{l}", workspace));
        _luaState.script_file(path);

        imgui_render();
        ImGuiLayer::createAndKeepOnTop();
        return true;
    }

    void LuaEntry::lua_third_register(sol::state_view &lua){
        sol::table d = lua.create_table("ding");
        //lua
        auto l_tb = d.create_named("lua");
        auto L = lua.lua_state();
        l_tb.set_function("getpeer", [=](){
            lua_getfenv(L, -1);
            if (lua_rawequal(L, -1, LUA_REGISTRYINDEX)) {
                lua_pop(L, 1);
                lua_pushnil(L);
            };
        });
        l_tb.set_function("setpeer", [=](){
          /* stack: userdata, table */
            if (!lua_isuserdata(L, -2)) {
                lua_pushstring(L, "Invalid argument #1 to setpeer: userdata expected.");
                lua_error(L);
            };

            if (lua_isnil(L, -1)) {

                lua_pop(L, 1);
                lua_pushvalue(L, LUA_REGISTRYINDEX);
            };
            lua_setfenv(L, -2);
        });

        d.set_function("guid", new_guid);
        d.set_function("bgSprite", [=](const std::string& filename, const cocos2d::Rect& rect) ->Sprite*{
            auto img = Director::getInstance()->getTextureCache()->addImage(filename);
            Texture2D::TexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
            img->setTexParameters(tp);
            auto sp = Sprite::createWithTexture(img, rect);
            return sp;
        });
        d.set_function("isMac", [=](void) ->bool {
            return CC_TARGET_PLATFORM == CC_PLATFORM_MAC;
        });
        d.new_usertype<SVGSprite>("SVGSprite",
                                  "create", &SVGSprite::create
                                  );
        d.new_usertype<FileDialogUtils>("FileDialogUtils", "GetSaveFile", &FileDialogUtils::GetSaveFile,
                                        "GetOpenFile", &FileDialogUtils::GetOpenFile);

    }

    void LuaEntry::imgui_render() {
        CCIMGUI::getInstance()->addImGUI([=]() {
                // schedule call lua function for render
                if (CCIMGUI::getInstance()->chineseFont)
                    ImGui::PushFont(CCIMGUI::getInstance()->chineseFont);
                {
                    _luaState["ImGuiRenderer"]();
                }
                if (CCIMGUI::getInstance()->chineseFont)
                    ImGui::PopFont();
                }, "dingcode-editor");
    }

    //---------------------------------
    //dev
    //---------------------------------
    void LuaEntry::lua_dev_register(sol::state_view &lua){
        //dev
        auto d = lua.get<sol::table>("ding");
        auto dev_tb = d.create_named("dev");
        dev_tb.set_function("show_imgui_demo", [=]{
            ImGui::ShowDemoWindow();
        });
    }

}
