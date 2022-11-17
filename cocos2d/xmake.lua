add_requires("opengl")


--debug 
set_allowedplats("windows")
add_defines("_WINDOWS")
--debug 

target("cocos2d")
    set_kind("shared")
    --compiler-set
    set_languages("c99", "cxx11")
    
    --global-set
    --TODO：check msvc version 
    --cocos编译默认描述
    --[[
        # not support other compile tools except MSVC for now
        # Visual Studio 2015, MSVC_VERSION 1900      (v140 toolset)
        # Visual Studio 2017, MSVC_VERSION 1910-1919 (v141 toolset)
    ]] 

    --TODO:
    --[[
    if(WINDOWS)
        target_compile_definitions(${target} 
            PUBLIC WIN32
            PUBLIC _WIN32
            PUBLIC _WINDOWS
            PUBLIC UNICODE
            PUBLIC _UNICODE
            PUBLIC _CRT_SECURE_NO_WARNINGS
            PUBLIC _SCL_SECURE_NO_WARNINGS
        )
        if(BUILD_SHARED_LIBS)
            target_compile_definitions(${target} 
                PUBLIC _USRDLL
                PUBLIC _EXPORT_DLL_
                PUBLIC _USEGUIDLL
                PUBLIC _USREXDLL
                PUBLIC _USE3DDLL
                PUBLIC _USRSTUDIODLL
            )
    endif()
    ]]
    --===========files===========
    
    add_includedirs("cocos")
    add_headerfiles("cocos/2d/*.h")
    add_files("cocos/2d/*.cpp")
    


    
    