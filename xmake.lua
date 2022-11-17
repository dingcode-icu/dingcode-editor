--[[
    dingcode-editor new 'makefile'
    replace NO.1 cmake :3
]]

--========
--core
--========
includes("cocos2d")

target("dingcode-editor")
    set_kind("binary")
    --Classes
    add_files("Classes/*.cpp")
    add_deps("cocos2d")
