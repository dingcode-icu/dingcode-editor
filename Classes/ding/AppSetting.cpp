#include "ding/AppSetting.h"
#include "ding/sys/cmdline.h"

namespace dan{

    

    void AppContext::load_parase(int argc, char *argv[]){
        cmdline::parser a;
        a.add<std::string>("respath", 'p', "the path of the resources", false, "");
        a.parse_check(argc, argv);
        
        std::string respath = a.get<std::string>("respath");
        setting.entry = respath;
    }
    
    void AppContext::load_config(){
        
    }
}
