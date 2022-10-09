#include "LuaEntry.h"
#include "lua.h"
//logger
#if defined(_WIN32) || defined(_WIN64)
#include <winsock2.h>
#endif
#include "logger/easylogging++.h"
INITIALIZE_EASYLOGGINGPP
//ding
#include "ding/common/StringUtil.h"
#include "ding/sol_cocos.h"
#include "ding/sys/FileDialogUtils.h"
#include "ding/guid/guid.h"


#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "sys/RemoteDebuger.h"
#endif
//imgui
#include "ImGuiExt/sol_imgui.h"
#include "ImGuiExt/CCImGuiLayer.h"
#include "ImGuiExt/CCIMGUI.h"
#include "svg/SvgSprite.h"

using namespace std;
USING_NS_CC;


/*
 * lua print打印复写
 * */
int lua_print(lua_State *L) {
    int n = lua_gettop(L);  /* number of arguments */
    int i;

    std::string out;
    lua_getglobal(L, "tostring");
    for (i = 1; i <= n; i++) {
        const char *s;
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
    LOG(INFO)<< out.c_str();
    return 0;
}

/*
 *创新新的guid
 * */
const char *new_guid() {
    int len = 64;
    char *ret = new char[len];
    ding::Guid guid = ding::guid::new_guid();
    return ding::guid::to_string(ret, len, guid);
}


namespace dan {

    LuaEntry::LuaEntry() {}

    LuaEntry::~LuaEntry() {}

    bool LuaEntry::entry() {
#if CC_TARGET_PLATFORM == CC_PLATFORM_MAC
        FileUtils::getInstance()->setDefaultResourceRootPath("res");
#endif
        this->init_logger();
        ding::guid_globals::init();
        //base 
        _luaState.open_libraries();
        _luaState["print"] = [&]() {
            lua_State *L = _luaState.lua_state();
            lua_print(L);
        };
        _luaState["ImGuiRenderer"] = []() {};
        sol::state_view luaView(_luaState.lua_state());
        //imgui+cocos init
        sol_ImGui::Init(luaView);
        sol_cocos2d::Init(luaView);
        //third bind
        lua_third_register(luaView);
        lua_dev_register(luaView);
        //load res/main.lua
        std::string name("main.lua");
        std::string workspace("");
        auto path = FileUtils::getInstance()->fullPathForFilename(name);
        workspace = path;
        workspace.replace(path.find(name), name.size(), "");
        FileUtils::getInstance()->setDefaultResourceRootPath(workspace);
        //../res
        FileUtils::getInstance()->addSearchResolutionsOrder(StringUtil::Replace("{l}/../res","{l}",workspace),true);

        std::string cmd("package.path = package.path..';{l}/?.lua;{l}/res/?.lua;{l}/?/init.lua;{l}/res/?/init.lua;'");
        _luaState.script(StringUtil::Replace(cmd, "{l}", workspace));
        _luaState.script_file(path);

        imgui_render();
        ImGuiLayer::createAndKeepOnTop();

        // 初始化 socket
        #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
        SmartSingleton<RemoteDebuger>::GetInstance()->init();
        #endif

        return true;
    }

    void LuaEntry::lua_third_register(sol::state_view &lua) {
        sol::table d = lua.create_table("ding");
        //lua
        auto l_tb = d.create_named("lua");
        auto L = lua.lua_state();
        l_tb.set_function("getpeer", [=]() {
            lua_getfenv(L, -1);
            if (lua_rawequal(L, -1, LUA_REGISTRYINDEX)) {
                lua_pop(L, 1);
                lua_pushnil(L);
            };
        });
        l_tb.set_function("setpeer", [=]() {
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
        d.set_function("bgSprite", [=](const std::string &filename, const cocos2d::Rect &rect) -> Sprite * {
            auto img = Director::getInstance()->getTextureCache()->addImage(filename);
            Texture2D::TexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
            img->setTexParameters(tp);
            auto sp = Sprite::createWithTexture(img, rect);
            return sp;
        });
        d.set_function("isMac", [=](void) -> bool {
            return CC_TARGET_PLATFORM == CC_PLATFORM_MAC;
        });

        d.set_function("setOnRecviedCallback", [=](const std::function<void(std::string str)>& callback){
            #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
            SmartSingleton<RemoteDebuger>::GetInstance()->setOnRecviedCallback(callback);
            #endif
        });



        d.set_function("showToast", [=](string desc){
            auto node = Node::create();
            node->setScale(0.7);
            auto scene = Director::getInstance()->getRunningScene();
            scene->addChild(node);

            auto bg = Sprite::create("assets/texture/bgtoast.png");
            node->addChild(bg);
            auto lab = Label::createWithTTF(desc, "font/FZLanTYJW.TTF", 30);
            node->addChild(lab);
            lab->setColor(Color3B::BLACK);
            auto labsize = lab->getContentSize();
            bg->setContentSize(cocos2d::Size(labsize.width + 30, labsize.height + 20));

            auto width = Director::getInstance()->getWinSize().width;
            auto height = Director::getInstance()->getWinSize().height;
            node->setPosition(width / 2, height / 2);

            auto scale1 = ScaleTo::create(0.1, 1.3);
            auto scale2 = ScaleTo::create(0.05, 1);
            auto delay = DelayTime::create(1.5);
            auto moveby = MoveBy::create(0.3f, Vec2(0, 100));
            auto call = CallFunc::create([=](){
                node->removeFromParentAndCleanup(true);
            });
            auto seq = Sequence::create(scale1, scale2, delay, moveby, call, NULL);
            node->runAction(seq);
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

    bool LuaEntry::init_logger() {
        el::Configurations c;
        c.setToDefault();
        // Values are always std::string
        c.set(el::Level::Info,
                        el::ConfigurationType::Format, "[dingcode]%datetime %level %msg");
        // default logger uses default configurations
        el::Loggers::reconfigureLogger("dingcode", c);
        el::Loggers::reconfigureAllLoggers(c);
        LOG(INFO) << "logger ready";
        return true;
    }

    //---------------------------------
    //dev
    //---------------------------------
    void LuaEntry::lua_dev_register(sol::state_view &lua) {
        //dev
        auto d = lua.get<sol::table>("ding");
        auto dev_tb = d.create_named("dev");
        dev_tb.set_function("show_imgui_demo", [=] {
            ImGui::ShowDemoWindow();
        });
    }

}
