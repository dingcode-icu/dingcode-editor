//
//  SmartSingleton.h
//  ImGuiX-desktop
//
//  Created by dwb on 2022/2/15.
//

#ifndef SmartSingleton_h
#define SmartSingleton_h
// SmartSingleton.hpp
#include<memory>
#include<mutex>


template<typename SType>
class SmartSingleton
{
public:
    template<typename... Args>
    static std::shared_ptr<SType> GetInstance(Args&&... args)
    {
        std::lock_guard<std::mutex> lg(mutexLock);
        if (pInstance == nullptr)
        {
            // 缺点 调用不到私有的构造函数 除非对应类将std::make_shared设置为友元函数
            // pInstance = std::make_shared<SType>(std::forward<Args>(args)...);
            pInstance = std::shared_ptr<SType>(new SType(std::forward<Args>(args)...));
        }
        return pInstance;
    }

    SmartSingleton() = delete;
    SmartSingleton(const SmartSingleton&) = delete;
    SmartSingleton& operator=(const SmartSingleton&) = delete;
private:
    static std::shared_ptr<SType> pInstance;
    static std::mutex mutexLock;
};

template<typename SType>
std::shared_ptr<SType> SmartSingleton<SType>::pInstance = nullptr;

template<typename SType>
std::mutex SmartSingleton<SType>::mutexLock;


#endif /* SmartSingleton_h */
