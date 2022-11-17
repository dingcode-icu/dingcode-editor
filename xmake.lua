--[[
    dingcode-editor new 'makefile'
    replace NO.1 cmake :3
]]

--debug win

add_defines("WINDOWS")
add_defines("_WINDOWS")
add_defines("_WIN32")
add_defines("_USRDLL")
add_defines("_EXPORT_DLL_")
add_defines("_USEGUIDLL")
add_defines("_USREXDLL")
add_defines("_USRSTUDIODLL")
add_defines("_USE3DDLL")


add_requires("luajit")
--========
--core
--========
includes("cocos2d")

target("dingcode-editor")
    set_kind("binary")
    set_languages("c99", "cxx17")
    --Classes
    
    add_packages("luajit")
    add_deps("cocos2d")

    add_includedirs("Classes")
    add_includedirs("third/sol/include")



    add_files("Classes/*/*.cpp")
    -- add_files("third/sol/include/**/*.hpp")
    -- add_files("third/sol/include/sol/*.hpp")