#include "AppDelegate.h"
#include "platform/CCGLView.h"
#include "ding/LuaEntry.h"
#include "ding/AppSetting.h"
#include "TEST.hpp"

USING_NS_CC;
static const int SCREEN_MIN_WIDTH = 960;
static const int SCREEN_MIN_HEIGHT = 640;


void onWinResizeCallback(GLFWwindow *win, int width, int height) {
    cocos2d::log("on win-resize width = %d, height =%d", width, height);
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    if(glview) {
        glview->setDesignResolutionSize((float)width, (float)height, ResolutionPolicy::SHOW_ALL);
        glview->setFrameSize((float)width, (float)height);
        director->reSetWinSize(width, height);
        director->setViewport();
    };
}

void onWinMaximizeCallback(GLFWwindow* win, int maximize){
    int width;
    int height;
    glfwGetWindowSize(win, &width, &height);
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    if(glview) {
        glview->setDesignResolutionSize((float)width, (float)height, ResolutionPolicy::SHOW_ALL);
        glview->setFrameSize((float)width, (float)height);
        director->reSetWinSize(width, height);
        director->setViewport();
    };
}

AppDelegate::AppDelegate() 
{
}

AppDelegate::~AppDelegate() 
{
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8, 4};

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching() {
    // initialize director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    if(!glview) {

        glview = GLViewImpl::createWithRect("dingcode", cocos2d::Rect(0, 0, SCREEN_MIN_WIDTH, SCREEN_MIN_HEIGHT), 1.0, true);
        //设置窗口
        this->init_glview(glview);
        director->setOpenGLView(glview);
    }

    director->getOpenGLView()->setDesignResolutionSize(SCREEN_MIN_WIDTH, SCREEN_MIN_HEIGHT, ResolutionPolicy::SHOW_ALL);

    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);
#if _DEBUG
    director->setDisplayStats(true);
#endif

    #if TESTFUNC == 1
       TESTFUNC;
       return true;
    #else
    auto e = new dan::LuaEntry();
    bool ret = e->entry();

    return ret;
    #endif
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    Director::getInstance()->stopAnimation();
    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    Director::getInstance()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}

void AppDelegate::init_glview(GLView* glview){
    auto impl = (GLViewImpl*)glview;
    auto win = impl->getWindow();
    glfwSetWindowSizeCallback(win, onWinResizeCallback);
    glfwSetWindowMaximizeCallback(win, onWinMaximizeCallback);


    //设置窗口大小
    int scene_cnt;
    GLFWmonitor** p = glfwGetMonitors(&scene_cnt);
    const GLFWvidmode* mode = glfwGetVideoMode(p[0]);
    cocos2d::log("screen glfw:width =  %d, height = %d", mode->width, mode->height);
    //设置窗口大小
    glfwSetWindowPos(win, mode->width / 2 - SCREEN_MIN_WIDTH / 2, mode->height / 2 - SCREEN_MIN_HEIGHT / 2);
    glfwSetWindowSizeLimits(win, SCREEN_MIN_WIDTH, SCREEN_MIN_HEIGHT, GLFW_DONT_CARE, GLFW_DONT_CARE);
    glfwShowWindow(win);
}

