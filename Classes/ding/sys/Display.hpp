#ifndef  __DISPLAY_H__
#define __DISPLAY_H__

#if defined(_WIN32) || defined(_WIN64)
#include <WinUser.h>
#elif defined (__MACOS__)
#include <CoreGraphics/CGDisplayConfiguration.h>
#endif

namespace dan{

class Display{
public:
    /*
     * 获取屏幕分辨率
     * @params width  unsigned int&
     * @params height  unsigned int&
     * */
    static void GetScreenSize(unsigned int& width, unsigned int& height){
        #if defined(_WIN32) || defined(_WIN64)
            width = (int) GetSystemMetrics(SM_CXSCREEN);
            height = (int) GetSystemMetrics(SM_CYSCREEN);
        #elif defined (__MACOS__)
            auto mainDisplayId = CGMainDisplayID();
            width = CGDisplayPixelsWide(mainDisplayId);
            height = CGDisplayPixelsHigh(mainDisplayId);
        #endif
    }
};

}

#endif