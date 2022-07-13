function(dingcode_platform_append PLATFORM_CLASSES_ PLATFORM_RESOURCES_)
    set(VAR_CLASS)
    set(VAR_RESOURCES)
    if (ANDROID)
        # change APP_NAME to the share library name for Android, it's value depend on AndroidManifest.xml
        set(APP_NAME cpp_empty_test)
        list(APPEND VAR_RESOURCES
                proj.android/app/jni/main.cpp
                )
    elseif (LINUX)
        list(APPEND VAR_RESOURCES
                proj.linux/main.cpp
                )
    elseif (WINDOWS)
        list(APPEND VAR_CLASS
                proj.win32/main.h
                )
        list(APPEND VAR_RESOURCES
                proj.win32/main.cpp
                ${cc_common_res}
                )
    elseif (APPLE)
        if (IOS)
            list(APPEND VAR_CLASS
                    proj.ios/AppController.h
                    proj.ios/RootViewController.h
                    )
            list(APPEND VAR_RESOURCES
                    proj.ios/main.m
                    proj.ios/AppController.mm
                    proj.ios/RootViewController.mm
                    ${APP_UI_RES}
                    )
        elseif (MACOSX)
            set(APP_UI_RES
                    proj.ios_mac/mac/Icon.icns
                    proj.ios_mac/mac/Info.plist
                    )
            list(APPEND VAR_RESOURCES
                    proj.ios_mac/mac/main.cpp
                    ${APP_UI_RES}
                    )
        endif ()
        list(APPEND VAR_RESOURCES ${cc_common_res})
    endif ()
    set(PLATFORM_RESOURCES_ ${VAR_RESOURCES} PARENT_SCOPE)
    set(PLATFORM_CLASSES_ ${VAR_CLASS} PARENT_SCOPE)
endfunction(dingcode_platform_append)


function(dingcode_android_link app_name all_code_files engine_binary_path)
    add_library(${APP_NAME} SHARED ${all_code_files})
    add_subdirectory(${COCOS2DX_ROOT_PATH}/cocos/platform/android ${ENGINE_BINARY_PATH}/cocos/platform)
    target_link_libraries(${APP_NAME} -Wl,--whole-archive cpp_android_spec -Wl,--no-whole-archive)
endfunction()
