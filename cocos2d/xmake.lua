add_defines("WINDOWS")
add_defines("_WINDOWS")
add_defines("_WIN32")
add_defines("_USRDLL")
add_defines("_EXPORT_DLL_")
add_defines("_USEGUIDLL")
add_defines("_USREXDLL")
add_defines("_USRSTUDIODLL")
add_defines("_USE3DDLL")

--from *xmake-repo* remote support
--del old prebuild win32 lib files
add_requires("glfw")

--win special
add_requires("opengl")

-- package("opengl")
--     on_load(function(package)
--         printf("--->>onload package is <%s>", package)
--     end)
-- package_end()


add_requires("freetype")
add_requires("zlib")
add_requires("libpng")
add_requires("libjpeg")
add_requires("sqlite3")
add_requires("libtiff")
add_requires("libuv")

package("edtaa3")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "edtaa3func"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
    on_test(function (package)
        --TODO:好用 下次加入test环节
        --assert(package:has_cfuncs("add", {includes = "foo.h"}))
    end)
package_end()
add_requires("edtaa3")


package("ConvertUTF")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "ConvertUTF"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
package_end()
add_requires("ConvertUTF")


package("flatbuffers")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "flatbuffers"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
package_end()
add_requires("flatbuffers")


package("md5")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "md5"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
    on_test(function (package)
        --TODO:好用 下次加入test环节
        --assert(package:has_cfuncs("add", {includes = "foo.h"}))
    end)
package_end()
add_requires("md5")


package("poly2tri")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "poly2tri"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
    on_test(function (package)
        --TODO:好用 下次加入test环节
        --assert(package:has_cfuncs("add", {includes = "foo.h"}))
    end)
package_end()
add_requires("poly2tri")


package("recast")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "recast"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
    on_test(function (package)
        --TODO:好用 下次加入test环节
        --assert(package:has_cfuncs("add", {includes = "foo.h"}))
    end)
package_end()
add_requires("recast")

package("tinyxml2")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "tinyxml2"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
    on_test(function (package)
        --TODO:好用 下次加入test环节
        --assert(package:has_cfuncs("add", {includes = "foo.h"}))
    end)
package_end()
add_requires("tinyxml2")


package("xxhash")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "xxhash"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
    on_test(function (package)
        --TODO:好用 下次加入test环节
        --assert(package:has_cfuncs("add", {includes = "foo.h"}))
    end)
package_end()
add_requires("xxhash")


package("xxtea")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "external", "xxtea"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
    on_test(function (package)
        --TODO:好用 下次加入test环节
        --assert(package:has_cfuncs("add", {includes = "foo.h"}))
    end)
package_end()
add_requires("xxtea")


target("cocos2d")
        -- ("shared")
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



    
    add_includedirs("cocos", {public = true })
    add_includedirs("external")
        add_includedirs("external/edtaa3func")
    
    --===========files=========== 
    
    add_headerfiles("cocos/2d/*.h")
    add_files("cocos/2d/*.cpp")

    --xmake-repo
    add_packages("glfw")
    -- add_packages("opengl")
    add_packages("freetype")
    add_packages("zlib")
    add_packages("libpng")
    add_packages("edtaa3")
    add_packages("sqlite3")
    add_packages("luajit")

    --cocos's old external code
    add_packages("ConvertUTF")
    add_packages("flatbuffers")
    add_packages("md5")
    add_packages("poly2tri")
    add_packages("rapidxml")
    add_packages("recast")
    add_packages("tinyxml2")
    add_packages("unzip")
    add_packages("xxhash")
    add_packages("xxtea")
        