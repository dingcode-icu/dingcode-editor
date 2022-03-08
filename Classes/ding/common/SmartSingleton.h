#ifndef SmartSingleton_h
#define SmartSingleton_h
#include<memory>
#include<mutex>

namespace dan {

    template<typename SType>
    class SmartSingleton {
    public:
        template<typename... Args>
        static std::shared_ptr<SType> GetInstance(Args &&... args) {
            std::lock_guard<std::mutex> lg(mutexLock);
            if (pInstance == nullptr) {
                pInstance = std::shared_ptr<SType>(new SType(std::forward<Args>(args)...));
            }
            return pInstance;
        }

        SmartSingleton() = delete;

        SmartSingleton(const SmartSingleton &) = delete;

        SmartSingleton &operator=(const SmartSingleton &) = delete;

    private:
        static std::shared_ptr<SType> pInstance;
        static std::mutex mutexLock;
    };

    template<typename SType>
    std::shared_ptr<SType> SmartSingleton<SType>::pInstance = nullptr;

    template<typename SType>
    std::mutex SmartSingleton<SType>::mutexLock;

}
#endif /* SmartSingleton_h */
