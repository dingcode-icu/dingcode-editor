#/****************************************************************************
# Copyright (c) 2015-2017 Chukong Technologies Inc.

# http://www.cocos2d-x.org
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ****************************************************************************/
cmake_minimum_required(VERSION 3.6)

set(APP_NAME dingcode-editor)
project(${APP_NAME})

if (NOT DEFINED BUILD_ENGINE_DONE)
    set(COCOS2DX_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cocos2d)
    set(CMAKE_MODULE_PATH ${COCOS2DX_ROOT_PATH}/cmake/Modules/)
    include(CocosBuildSet)
    add_subdirectory(${COCOS2DX_ROOT_PATH}/cocos ${ENGINE_BINARY_PATH}/cocos/core)
endif ()

# record sources, headers, resources...
set(GAME_SOURCE)
set(GAME_HEADER)
set(GAME_RES_FOLDER
        "${CMAKE_CURRENT_SOURCE_DIR}/res"
        )

#[[
-------------*---------------------------*-------------
-------------*-获取Classes目录下所有代码文件-*-------------
*/]]
#ROOT
list(APPEND GAME_HEADER
        Classes/AppDelegate.h
        )
list(APPEND GAME_SOURCE
        Classes/TEST.hpp
        Classes/AppDelegate.cpp
        )
#IMGUI
set(IMGUIEXT_CLASSES_)
file(GLOB_RECURSE IMGUIEXT_CLASSES_ Classes/ImGuiExt/**.h Classes/ImGuiExt/**.cpp Classes/ImGuiExt/**.mm)
#DING
set(DING_CLASSES_)
file(GLOB_RECURSE DING_CLASSES_ Classes/ding/**.h Classes/ding/**.cpp Classes/ding/**.inl_)
add_definitions(-DSOL_NO_EXCEPTIONS=0 -DSOL_IMGUI_IMPLEMENTATION=1 -DWIN32_LEAN_AND_MEAN=1)
#LOGGER
set(LOGGER_CLASSES_)
file(GLOB_RECURSE LOGGER_CLASSES_ Classes/logger/**.h Classes/logger/**.cc)
#SVG
set(SVG_CLASSES_)
file(GLOB_RECURSE SVG_CLASSES_ Classes/svg/**.h Classes/svg/**.cpp)
#MOBILE FILES
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
include(MobileDevice)
dingcode_platform_append(PLATFORM_CLASSES_ PLATFORM_RESOURCES_)
set(all_code_files
        ${IMGUIEXT_CLASSES_}
        ${DING_CLASSES_}
        ${LOGGER_CLASSES_}
        ${SVG_CLASSES_}
        ${GAME_HEADER}
        ${GAME_SOURCE}
        ${PLATFORM_CLASSES_}
        ${PLATFORM_RESOURCES_}
        )


#[[
-------------*----------------*-------------
-------------*-run executable-*-------------
*/]]
if (NOT ANDROID)
    add_executable(${APP_NAME} ${all_code_files})
else ()
    #only in android
    #build cocos android dynamic libcocos.so
    #output cocos lib
    dingcode_android_link(${APP_NAME} ${all_code_files} ${ENGINE_BINARY_PATH})
endif ()

target_link_libraries(${APP_NAME} cocos2d)
target_include_directories(${APP_NAME} PRIVATE Classes)
target_include_directories(${APP_NAME} PRIVATE ${COCOS2DX_ROOT_PATH}/external/luajit/include)

# mark app resources
setup_cocos_app_config(${APP_NAME})


#[[
-------------*----------------*-------------
-------------*-third library -*-------------
*/]]
include(NaLibrary)
dingcode_append_nfd()
if (APPLE)
    set_target_properties(${APP_NAME} PROPERTIES RESOURCE "${APP_UI_RES}")
    if (MACOSX)
        set_target_properties(${APP_NAME} PROPERTIES
                MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/proj.ios_mac/mac/Info.plist"
                )
    elseif (IOS)
        cocos_pak_xcode(${APP_NAME} INFO_PLIST "iOSBundleInfo.plist.in")
        set_xcode_property(${APP_NAME} ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon-${APP_NAME}")
    endif ()
elseif (WINDOWS)
    cocos_copy_target_dll(${APP_NAME} COPY_TO ${APP_RES_DIR}/..)
endif ()

if (LINUX OR WINDOWS)
    cocos_copy_res(COPY_TO ${APP_RES_DIR} FOLDERS ${GAME_RES_FOLDER})
endif ()
if (MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++17 /Zm100 /GX /GZ")
endif (MSVC)
