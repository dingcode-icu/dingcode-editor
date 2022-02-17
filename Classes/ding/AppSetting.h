#ifndef AppSetting_h
#define AppSetting_h


#include "ding/SmartSingleton.h"


namespace dan {
   
    /**
     全局配置
     */
    struct AppSetting{
        std::string entry;
        AppSetting(std::string e){
            entry = e;
        };
    };

    /**
     App运行上下文
     */
    class AppContext{
        friend class SmartSingleton<AppSetting>;
    private:
        AppContext():setting(setting){
        };
    public:
        /**
         从外部传参读取
         */
        void load_parase(int argc, char *argv[]);
        /**
         从本地读取配置
         */
        void load_config();
    private:
        AppSetting &setting;
    };
}

#endif /* AppSetting_h */
