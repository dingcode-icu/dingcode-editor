
#include "ding/AppSetting.h"

#if defined(_WIN32) || defined(_WIN64)
#include "processenv.h"
#endif
namespace  dan {

void test_dwb(){

#if defined(_WIN32) || defined(_WIN64)
    auto a_cmd = GetCommandLineA();
//    auto context = SmartSingleton<AppContext>::GetInstance();
//    context->load_parase();
#endif
}
}


#define TEST test_dwb();