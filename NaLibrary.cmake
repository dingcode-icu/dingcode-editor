
function(dingcode_append_nfd)
    if (MACOSX)
        target_include_directories(${APP_NAME} PRIVATE third/libnfd/include)
        target_link_directories(${APP_NAME} PRIVATE third/libnfd/lib/mac)
        target_link_libraries(${APP_NAME} libfd)
    elseif (WINDOWS)
        target_include_directories(${APP_NAME} PRIVATE third/libnfd/include)
        target_link_directories(${APP_NAME} PRIVATE third/libnfd/lib/win32)
        target_link_libraries(${APP_NAME} nfd)
    endif ()
endfunction()


