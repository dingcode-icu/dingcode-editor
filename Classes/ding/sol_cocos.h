#pragma once

#include <string>
#include "cocos2d.h"
#include "platform/CCGLView.h"

#define SOL_ALL_SAFETIES_ON 1
#define SOL_DEFAULT_PASS_ON_ERROR 1
#include "sol/sol.hpp"
using namespace cocos2d;

namespace sol_cocos2d {
    inline void Init(sol::state_view& lua);

    //sprite
    inline Sprite* spriteCreate1(const std::string& filename){ return Sprite::create(filename);}
    inline Sprite* spriteCreate2(const std::string& filename, const cocos2d::Rect& rect){ return Sprite::create(filename, rect);}

    //ccTypes
    static Color3B c3b_from_lua_table(sol::table t){
        Color3B c;
        c.r = t[1];
        c.g = t[2];
        c.b = t[3];
        return c;
    }
};


#ifdef SOL_IMGUI_IMPLEMENTATION
namespace sol_cocos2d {

inline void Init(sol::state_view& lua){
    sol::table CC = lua.create_named_table("cc");
#pragma region ccTypes
    auto c3b = CC.new_usertype<Color3B>("c3b",
                              sol::call_constructor,sol::constructors<sol::types<int, int, int>>()
                           );
    c3b["r"] = &Color3B::r;
    c3b["g"] = &Color3B::g;
    c3b["b"] = &Color3B::b;


    auto point = CC.new_usertype<Vec2>("p",
                                       sol::call_constructor, sol::constructors<sol::types<float, float>>());
    point["x"] = &Vec2::x;
    point["y"] = &Vec2::y;

    auto rect = CC.new_usertype<cocos2d::Rect>("rect",
                                      sol::call_constructor, sol::constructors<sol::types<float, float, float, float>>());

#pragma endregion ccTypes

#pragma region Instance
    CC.new_usertype<Director>("Director",
                              "getInstance", &Director::getInstance,
                              "getRunningScene", &Director::getRunningScene,
                              "getWinSize", &Director::getWinSize,
                              "runWithScene", &Director::runWithScene,
                              "getOpenGLView", &Director::getOpenGLView,
                              "getTextureCache", &Director::getTextureCache,
                              "getWinSize", &Director::getWinSize,
                              "getContentScaleFactor", &Director::getContentScaleFactor,
                              "replaceScene", &Director::runWithScene,
                              "runWithScene", &Director::runWithScene,
                              "getScheduler", &Director::getScheduler
                              );
    CC.new_usertype<FileUtils>(
        "FileUtils",
        "getInstance", &FileUtils::getInstance,
        "getDefaultResourceRootPath", &FileUtils::getDefaultResourceRootPath
        );
    
    
#pragma endregion Instance
 
#pragma region GLViewImpl
    CC.new_usertype<GLViewImpl>("GLViewImpl",
                                "createWithRect", &GLViewImpl::createWithRect,
                                "setDesignResolutionSize", &GLViewImpl::setDesignResolutionSize);
    CC.new_usertype<GLView>("GLView",
                            "getFrameSize", &GLView::getFrameSize);
#pragma endregion GLViewImpl

#pragma region SpriteFrameCache
    CC.new_usertype<SpriteFrameCache>("SpriteFrameCache",
                                      "getInstance", &SpriteFrameCache::getInstance);

#pragma endregion SpriteFrameCache

#pragma region Scene
    CC.new_usertype<Scene>("Scene",
                            "create",&Scene::create,
                            "createWithPhysics", &Scene::createWithPhysics);
#pragma endregion Scene

#pragma region AnimationCache
     CC.new_usertype<AnimationCache>("AnimationCache",
                                     "getInstance", &AnimationCache::getInstance);
#pragma endregion AnimationCache

#pragma region Node
     CC.new_usertype<Node>("Node",
                           "create", &Node::create
                           );
#pragma endregion Node

#pragma region Layer
     CC.new_usertype<Layer>("Layer",
                           "create", &Layer::create
                           );
#pragma endregion Layer

#pragma region Sprite

     auto sp_tb =CC.new_usertype<Sprite>("Sprite");
     sp_tb.set_function("create", sol::overload(
             sol::resolve<Sprite*(const std::string& filename)>(spriteCreate1),
             sol::resolve<Sprite*(const std::string &, const cocos2d::Rect &)>(spriteCreate2)
             ));
//     sp_tb.set_function()
#pragma endregion Sprite


#pragma region Texture2D
//     CC.new_usertype<Texture2D>()
#pragma endregion Texture2D


#pragma region TextureCache
//     CC.new_usertype<TextureCache>("TextureCache",
//                                   "removeTextureForKey", &TextureCache::removeTextureForKey,
//                                   "getTextureForKey", &TextureCache::getTextureForKey,
//                                   "addImage", &TextureCache::addImage,
//                                   "addImageAsync", &TextureCache::addImageAsync);
#pragma endregion TextureCache

}
}
#endif

