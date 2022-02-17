#pragma once

#include <string>
#include "cocos2d.h"
#include "platform/CCGLView.h"

#define SOL_ALL_SATETIES_ON 1
#include "sol/sol.hpp"
using namespace cocos2d;

namespace sol_cocos2d {
    inline void Init(sol::state_view& lua);

};


#ifdef SOL_IMGUI_IMPLEMENTATION
namespace sol_cocos2d {

inline void Init(sol::state_view& lua){
    sol::table CC = lua.create_named_table("cc");

#pragma region Instance
    CC.new_usertype<Director>("Director",
                              "getInstance", &Director::getInstance,
                              "getRunningScene", &Director::getRunningScene,
                              "getWinSize", &Director::getWinSize,
                              "runWithScene", &Director::runWithScene
                              );
    CC.new_usertype<FileUtils>(
        "FileUtils",
        "getInstance", &FileUtils::getInstance,
        "getDefaultResourceRootPath", &FileUtils::getDefaultResourceRootPath
        );
    
    
#pragma endregion Instance
 
#pragma region GLViewImpl
    
    
#pragma endregion GLViewImpl
    
    
#pragma region Scene
    
    

    
    CC.new_usertype<Scene>("Scene",
                            "create",&Scene::create);;
#pragma endregion Scene
}
}
#endif

