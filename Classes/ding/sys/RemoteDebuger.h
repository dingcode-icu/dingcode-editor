//
//  RemoteDebuger.h
//  ImGuiX-desktop
//
//  Created by Mac on 2022/3/29.
//

#ifndef RemoteDebuger_h
#define RemoteDebuger_h


#include <stdio.h>
#include "ding/common/SmartSingleton.h"

namespace dan {

    class RemoteDebuger {

        friend class SmartSingleton<RemoteDebuger>;

    private:
        // 收到消息的lua 回调
        std::function<void(std::string str)> _onRecviedCallback;

    public:

        RemoteDebuger();

        ~RemoteDebuger();

        bool init();

        void setOnRecviedCallback(const std::function<void(std::string str)>& callback) { _onRecviedCallback = callback; }
        const std::function<void(std::string str)>& getOnRecviedCallback() const { return _onRecviedCallback; }
    };
}

#endif /* RemoteDebuger_h */
