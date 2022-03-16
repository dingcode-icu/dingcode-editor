#pragma once

#include <string>
#include "cocos2d.h"
#include "platform/CCGLView.h"

#define SOL_DEFAULT_PASS_ON_ERROR 1
#include "sol/sol.hpp"
using namespace cocos2d;

namespace sol_cocos2d {
    inline void Init(sol::state_view& lua);
    //sprite
    inline Label* createWithTTF(const std::string& text, const std::string& fontFile, float fontSize){return Label::createWithTTF(text, fontFile, fontSize);}
    //fileutil
    inline auto getSearchPath(){return sol::as_table(FileUtils::getInstance()->getSearchPaths());}
    inline auto setSearchPaths(sol::as_table_t<std::vector<std::string>> o){return FileUtils::getInstance()->setSearchPaths(o.value());}
};


#ifdef SOL_IMGUI_IMPLEMENTATION
namespace sol_cocos2d {

inline void Init(sol::state_view& lua){
    sol::table CC = lua.create_named_table("cc");

#pragma region ENUM

    CC.create_named("KeyBoardCode",
                    "KEY_NONE", EventKeyboard::KeyCode::KEY_NONE,
                    "KEY_PAUSE",EventKeyboard::KeyCode::KEY_PAUSE,
                    "KEY_SCROLL_LOCK",EventKeyboard::KeyCode::KEY_SCROLL_LOCK,
                    "KEY_PRINT",EventKeyboard::KeyCode::KEY_PRINT,
                    "KEY_SYSREQ",EventKeyboard::KeyCode::KEY_SYSREQ,
                    "KEY_BREAK",EventKeyboard::KeyCode::KEY_BREAK,
                    "KEY_ESCAPE",EventKeyboard::KeyCode::KEY_ESCAPE,
                    "KEY_BACK", EventKeyboard::KeyCode::KEY_BACK,
                    "KEY_ESCAPE",EventKeyboard::KeyCode::KEY_ESCAPE,
                    "KEY_BACKSPACE",EventKeyboard::KeyCode::KEY_BACKSPACE,
                    "KEY_TAB",EventKeyboard::KeyCode::KEY_TAB,
                    "KEY_BACK_TAB",EventKeyboard::KeyCode::KEY_BACK_TAB,
                    "KEY_RETURN",EventKeyboard::KeyCode::KEY_RETURN,
                    "KEY_CAPS_LOCK",EventKeyboard::KeyCode::KEY_CAPS_LOCK,
                    "KEY_SHIFT",EventKeyboard::KeyCode::KEY_SHIFT,
                    "KEY_LEFT_SHIFT", EventKeyboard::KeyCode::KEY_LEFT_SHIFT,
                    "KEY_SHIFT",EventKeyboard::KeyCode::KEY_SHIFT,
                    "KEY_RIGHT_SHIFT",EventKeyboard::KeyCode::KEY_RIGHT_SHIFT,
                    "KEY_CTRL",EventKeyboard::KeyCode::KEY_CTRL,
                    "KEY_LEFT_CTRL", EventKeyboard::KeyCode::KEY_LEFT_CTRL,
                    "KEY_CTRL",EventKeyboard::KeyCode::KEY_CTRL,
                    "KEY_RIGHT_CTRL",EventKeyboard::KeyCode::KEY_RIGHT_CTRL,
                    "KEY_ALT",EventKeyboard::KeyCode::KEY_ALT,
                    "KEY_LEFT_ALT",EventKeyboard::KeyCode::KEY_LEFT_ALT,
                    "KEY_ALT",EventKeyboard::KeyCode::KEY_ALT,
                    "KEY_RIGHT_ALT",EventKeyboard::KeyCode::KEY_RIGHT_ALT,
                    "KEY_MENU",EventKeyboard::KeyCode::KEY_MENU,
                    "KEY_HYPER",EventKeyboard::KeyCode::KEY_HYPER,
                    "KEY_INSERT",EventKeyboard::KeyCode::KEY_INSERT,
                    "KEY_HOME",EventKeyboard::KeyCode::KEY_HOME,
                    "KEY_PG_UP",EventKeyboard::KeyCode::KEY_PG_UP,
                    "KEY_DELETE",EventKeyboard::KeyCode::KEY_DELETE,
                    "KEY_END",EventKeyboard::KeyCode::KEY_END,
                    "KEY_PG_DOWN",EventKeyboard::KeyCode::KEY_PG_DOWN,
                    "KEY_LEFT_ARROW",EventKeyboard::KeyCode::KEY_LEFT_ARROW,
                    "KEY_RIGHT_ARROW",EventKeyboard::KeyCode::KEY_RIGHT_ARROW,
                    "KEY_UP_ARROW",EventKeyboard::KeyCode::KEY_UP_ARROW,
                    "KEY_DOWN_ARROW",EventKeyboard::KeyCode::KEY_DOWN_ARROW,
                    "KEY_NUM_LOCK",EventKeyboard::KeyCode::KEY_NUM_LOCK,
                    "KEY_KP_PLUS",EventKeyboard::KeyCode::KEY_KP_PLUS,
                    "KEY_KP_MINUS",EventKeyboard::KeyCode::KEY_KP_MINUS,
                    "KEY_KP_MULTIPLY",EventKeyboard::KeyCode::KEY_KP_MULTIPLY,
                    "KEY_KP_DIVIDE",EventKeyboard::KeyCode::KEY_KP_DIVIDE,
                    "KEY_KP_ENTER",EventKeyboard::KeyCode::KEY_KP_ENTER,
                    "KEY_KP_HOME",EventKeyboard::KeyCode::KEY_KP_HOME,
                    "KEY_KP_UP",EventKeyboard::KeyCode::KEY_KP_UP,
                    "KEY_KP_PG_UP",EventKeyboard::KeyCode::KEY_KP_PG_UP,
                    "KEY_KP_LEFT",EventKeyboard::KeyCode::KEY_KP_LEFT,
                    "KEY_KP_FIVE",EventKeyboard::KeyCode::KEY_KP_FIVE,
                    "KEY_KP_RIGHT",EventKeyboard::KeyCode::KEY_KP_RIGHT,
                    "KEY_KP_END",EventKeyboard::KeyCode::KEY_KP_END,
                    "KEY_KP_DOWN",EventKeyboard::KeyCode::KEY_KP_DOWN,
                    "KEY_KP_PG_DOWN",EventKeyboard::KeyCode::KEY_KP_PG_DOWN,
                    "KEY_KP_INSERT",EventKeyboard::KeyCode::KEY_KP_INSERT,
                    "KEY_KP_DELETE",EventKeyboard::KeyCode::KEY_KP_DELETE,
                    "KEY_F1",EventKeyboard::KeyCode::KEY_F1,
                    "KEY_F2",EventKeyboard::KeyCode::KEY_F2,
                    "KEY_F3",EventKeyboard::KeyCode::KEY_F3,
                    "KEY_F4",EventKeyboard::KeyCode::KEY_F4,
                    "KEY_F5",EventKeyboard::KeyCode::KEY_F5,
                    "KEY_F6",EventKeyboard::KeyCode::KEY_F6,
                    "KEY_F7",EventKeyboard::KeyCode::KEY_F7,
                    "KEY_F8",EventKeyboard::KeyCode::KEY_F8,
                    "KEY_F9",EventKeyboard::KeyCode::KEY_F9,
                    "KEY_F10",EventKeyboard::KeyCode::KEY_F10,
                    "KEY_F11",EventKeyboard::KeyCode::KEY_F11,
                    "KEY_F12",EventKeyboard::KeyCode::KEY_F12,
                    "KEY_SPACE",EventKeyboard::KeyCode::KEY_SPACE,
                    "KEY_EXCLAM",EventKeyboard::KeyCode::KEY_EXCLAM,
                    "KEY_QUOTE",EventKeyboard::KeyCode::KEY_QUOTE,
                    "KEY_NUMBER",EventKeyboard::KeyCode::KEY_NUMBER,
                    "KEY_DOLLAR",EventKeyboard::KeyCode::KEY_DOLLAR,
                    "KEY_PERCENT",EventKeyboard::KeyCode::KEY_PERCENT,
                    "KEY_CIRCUMFLEX",EventKeyboard::KeyCode::KEY_CIRCUMFLEX,
                    "KEY_AMPERSAND",EventKeyboard::KeyCode::KEY_AMPERSAND,
                    "KEY_APOSTROPHE",EventKeyboard::KeyCode::KEY_APOSTROPHE,
                    "KEY_LEFT_PARENTHESIS",EventKeyboard::KeyCode::KEY_LEFT_PARENTHESIS,
                    "KEY_RIGHT_PARENTHESIS",EventKeyboard::KeyCode::KEY_RIGHT_PARENTHESIS,
                    "KEY_ASTERISK",EventKeyboard::KeyCode::KEY_ASTERISK,
                    "KEY_PLUS",EventKeyboard::KeyCode::KEY_PLUS,
                    "KEY_COMMA",EventKeyboard::KeyCode::KEY_COMMA,
                    "KEY_MINUS",EventKeyboard::KeyCode::KEY_MINUS,
                    "KEY_PERIOD",EventKeyboard::KeyCode::KEY_PERIOD,
                    "KEY_SLASH",EventKeyboard::KeyCode::KEY_SLASH,
                    "KEY_0",EventKeyboard::KeyCode::KEY_0,
                    "KEY_1",EventKeyboard::KeyCode::KEY_1,
                    "KEY_2",EventKeyboard::KeyCode::KEY_2,
                    "KEY_3",EventKeyboard::KeyCode::KEY_3,
                    "KEY_4",EventKeyboard::KeyCode::KEY_4,
                    "KEY_5",EventKeyboard::KeyCode::KEY_5,
                    "KEY_6",EventKeyboard::KeyCode::KEY_6,
                    "KEY_7",EventKeyboard::KeyCode::KEY_7,
                    "KEY_8",EventKeyboard::KeyCode::KEY_8,
                    "KEY_9",EventKeyboard::KeyCode::KEY_9,
                    "KEY_COLON",EventKeyboard::KeyCode::KEY_COLON,
                    "KEY_SEMICOLON",EventKeyboard::KeyCode::KEY_SEMICOLON,
                    "KEY_LESS_THAN",EventKeyboard::KeyCode::KEY_LESS_THAN,
                    "KEY_EQUAL",EventKeyboard::KeyCode::KEY_EQUAL,
                    "KEY_GREATER_THAN",EventKeyboard::KeyCode::KEY_GREATER_THAN,
                    "KEY_QUESTION",EventKeyboard::KeyCode::KEY_QUESTION,
                    "KEY_AT",EventKeyboard::KeyCode::KEY_AT,
                    "KEY_CAPITAL_A",EventKeyboard::KeyCode::KEY_CAPITAL_A,
                    "KEY_CAPITAL_B",EventKeyboard::KeyCode::KEY_CAPITAL_B,
                    "KEY_CAPITAL_C",EventKeyboard::KeyCode::KEY_CAPITAL_C,
                    "KEY_CAPITAL_D",EventKeyboard::KeyCode::KEY_CAPITAL_D,
                    "KEY_CAPITAL_E",EventKeyboard::KeyCode::KEY_CAPITAL_E,
                    "KEY_CAPITAL_F",EventKeyboard::KeyCode::KEY_CAPITAL_F,
                    "KEY_CAPITAL_G",EventKeyboard::KeyCode::KEY_CAPITAL_G,
                    "KEY_CAPITAL_H",EventKeyboard::KeyCode::KEY_CAPITAL_H,
                    "KEY_CAPITAL_I",EventKeyboard::KeyCode::KEY_CAPITAL_I,
                    "KEY_CAPITAL_J",EventKeyboard::KeyCode::KEY_CAPITAL_J,
                    "KEY_CAPITAL_K",EventKeyboard::KeyCode::KEY_CAPITAL_K,
                    "KEY_CAPITAL_L",EventKeyboard::KeyCode::KEY_CAPITAL_L,
                    "KEY_CAPITAL_M",EventKeyboard::KeyCode::KEY_CAPITAL_M,
                    "KEY_CAPITAL_N",EventKeyboard::KeyCode::KEY_CAPITAL_N,
                    "KEY_CAPITAL_O",EventKeyboard::KeyCode::KEY_CAPITAL_O,
                    "KEY_CAPITAL_P",EventKeyboard::KeyCode::KEY_CAPITAL_P,
                    "KEY_CAPITAL_Q",EventKeyboard::KeyCode::KEY_CAPITAL_Q,
                    "KEY_CAPITAL_R",EventKeyboard::KeyCode::KEY_CAPITAL_R,
                    "KEY_CAPITAL_S",EventKeyboard::KeyCode::KEY_CAPITAL_S,
                    "KEY_CAPITAL_T",EventKeyboard::KeyCode::KEY_CAPITAL_T,
                    "KEY_CAPITAL_U",EventKeyboard::KeyCode::KEY_CAPITAL_U,
                    "KEY_CAPITAL_V",EventKeyboard::KeyCode::KEY_CAPITAL_V,
                    "KEY_CAPITAL_W",EventKeyboard::KeyCode::KEY_CAPITAL_W,
                    "KEY_CAPITAL_X",EventKeyboard::KeyCode::KEY_CAPITAL_X,
                    "KEY_CAPITAL_Y",EventKeyboard::KeyCode::KEY_CAPITAL_Y,
                    "KEY_CAPITAL_Z",EventKeyboard::KeyCode::KEY_CAPITAL_Z,
                    "KEY_LEFT_BRACKET",EventKeyboard::KeyCode::KEY_LEFT_BRACKET,
                    "KEY_BACK_SLASH",EventKeyboard::KeyCode::KEY_BACK_SLASH,
                    "KEY_RIGHT_BRACKET",EventKeyboard::KeyCode::KEY_RIGHT_BRACKET,
                    "KEY_UNDERSCORE",EventKeyboard::KeyCode::KEY_UNDERSCORE,
                    "KEY_GRAVE",EventKeyboard::KeyCode::KEY_GRAVE,
                    "KEY_A",EventKeyboard::KeyCode::KEY_A,
                    "KEY_B",EventKeyboard::KeyCode::KEY_B,
                    "KEY_C",EventKeyboard::KeyCode::KEY_C,
                    "KEY_D",EventKeyboard::KeyCode::KEY_D,
                    "KEY_E",EventKeyboard::KeyCode::KEY_E,
                    "KEY_F",EventKeyboard::KeyCode::KEY_F,
                    "KEY_G",EventKeyboard::KeyCode::KEY_G,
                    "KEY_H",EventKeyboard::KeyCode::KEY_H,
                    "KEY_I",EventKeyboard::KeyCode::KEY_I,
                    "KEY_J",EventKeyboard::KeyCode::KEY_J,
                    "KEY_K",EventKeyboard::KeyCode::KEY_K,
                    "KEY_L",EventKeyboard::KeyCode::KEY_L,
                    "KEY_M",EventKeyboard::KeyCode::KEY_M,
                    "KEY_N",EventKeyboard::KeyCode::KEY_N,
                    "KEY_O",EventKeyboard::KeyCode::KEY_O,
                    "KEY_P",EventKeyboard::KeyCode::KEY_P,
                    "KEY_Q",EventKeyboard::KeyCode::KEY_Q,
                    "KEY_R",EventKeyboard::KeyCode::KEY_R,
                    "KEY_S",EventKeyboard::KeyCode::KEY_S,
                    "KEY_T",EventKeyboard::KeyCode::KEY_T,
                    "KEY_U",EventKeyboard::KeyCode::KEY_U,
                    "KEY_V",EventKeyboard::KeyCode::KEY_V,
                    "KEY_W",EventKeyboard::KeyCode::KEY_W,
                    "KEY_X",EventKeyboard::KeyCode::KEY_X,
                    "KEY_Y",EventKeyboard::KeyCode::KEY_Y,
                    "KEY_Z",EventKeyboard::KeyCode::KEY_Z,
                    "KEY_LEFT_BRACE",EventKeyboard::KeyCode::KEY_LEFT_BRACE,
                    "KEY_BAR",EventKeyboard::KeyCode::KEY_BAR,
                    "KEY_RIGHT_BRACE",EventKeyboard::KeyCode::KEY_RIGHT_BRACE,
                    "KEY_TILDE",EventKeyboard::KeyCode::KEY_TILDE,
                    "KEY_EURO",EventKeyboard::KeyCode::KEY_EURO,
                    "KEY_POUND",EventKeyboard::KeyCode::KEY_POUND,
                    "KEY_YEN",EventKeyboard::KeyCode::KEY_YEN,
                    "KEY_MIDDLE_DOT",EventKeyboard::KeyCode::KEY_MIDDLE_DOT,
                    "KEY_SEARCH",EventKeyboard::KeyCode::KEY_SEARCH,
                    "KEY_DPAD_LEFT",EventKeyboard::KeyCode::KEY_DPAD_LEFT,
                    "KEY_DPAD_RIGHT",EventKeyboard::KeyCode::KEY_DPAD_RIGHT,
                    "KEY_DPAD_UP",EventKeyboard::KeyCode::KEY_DPAD_UP,
                    "KEY_DPAD_DOWN",EventKeyboard::KeyCode::KEY_DPAD_DOWN,
                    "KEY_DPAD_CENTER",EventKeyboard::KeyCode::KEY_DPAD_CENTER,
                    "KEY_ENTER",EventKeyboard::KeyCode::KEY_ENTER,
                     "KEY_PLAY",EventKeyboard::KeyCode::KEY_PLAY
                    );

#pragma endregion ENUM


#pragma region ccTypes
    auto c3b = CC.new_usertype<Color3B>("c3b",
                              sol::call_constructor,sol::constructors<sol::types<int, int, int>>()
                           );
    c3b["r"] = &Color3B::r;
    c3b["g"] = &Color3B::g;
    c3b["b"] = &Color3B::b;

    auto c4f = CC.new_usertype<Color4F>("c4f",
                              sol::call_constructor,sol::constructors<sol::types<float, float, float, float>>()
    );
    auto c4b = CC.new_usertype<Color4B>("c4b",
                              sol::call_constructor,sol::constructors<sol::types<int, int, int, int>>()
    );


    auto point = CC.new_usertype<Vec2>("p",
                                       sol::call_constructor, sol::constructors<sol::types<float, float>>());
    point["x"] = &Vec2::x;
    point["y"] = &Vec2::y;

    auto rect = CC.new_usertype<cocos2d::Rect>("rect",
                                      sol::call_constructor, sol::constructors<sol::types<float, float, float, float>>(),
                                      "containsPoint", &cocos2d::Rect::containsPoint,
                                      "getMinX", &cocos2d::Rect::getMinX,
                                      "getMaxX", &cocos2d::Rect::getMaxX,
                                      "getMinY", &cocos2d::Rect::getMinY,
                                      "getMaxY", &cocos2d::Rect::getMaxY
                                      );

    auto size = CC.new_usertype<cocos2d::Size>("size",
                                      sol::call_constructor, sol::constructors<sol::types<float, float>>(),
                                      "width",&cocos2d::Size::width,
                                      "height",&cocos2d::Size::height
                                      );



#pragma endregion ccTypes


#pragma region Instance
    CC.new_usertype<Director>("Director",
                              "getInstance", &Director::getInstance,
                              "getRunningScene", &Director::getRunningScene,
                              "getWinSize", &Director::getWinSize,
                              "runWithScene", &Director::runWithScene,
                              "getOpenGLView", &Director::getOpenGLView,
                              "getTextureCache", &Director::getTextureCache,
                              "getWinSize", &Director::getWinSize,
                              "getContentScaleFactor", &Director::getContentScaleFactor,
                              "replaceScene", &Director::runWithScene,
                              "runWithScene", &Director::runWithScene,
                              "getScheduler", &Director::getScheduler,
                              "getEventDispatcher", &Director::getEventDispatcher
                              );
    auto fu = CC.new_usertype<FileUtils>(
        "FileUtils",
        "getInstance", &FileUtils::getInstance,
        "getDefaultResourceRootPath", &FileUtils::getDefaultResourceRootPath
        );
    fu.set_function("getSearchPaths", getSearchPath);
    fu.set_function("setSearchPaths", setSearchPaths);


    CC.new_usertype<UserDefault>("UserDefault",
                                 "getInstance", &UserDefault::getInstance
                                 );

#pragma endregion Instance


#pragma region GLViewImpl
    CC.new_usertype<GLViewImpl>("GLViewImpl",
                                "createWithRect", &GLViewImpl::createWithRect,
                                "setDesignResolutionSize", &GLViewImpl::setDesignResolutionSize);
    CC.new_usertype<GLView>("GLView",
                            "getFrameSize", &GLView::getFrameSize);
#pragma endregion GLViewImpl


#pragma region SpriteFrameCache
    CC.new_usertype<SpriteFrameCache>("SpriteFrameCache",
                                      "getInstance", &SpriteFrameCache::getInstance);

#pragma endregion SpriteFrameCache


#pragma region Scene
    CC.new_usertype<Scene>("Scene",
                            sol::call_constructor, sol::constructors<Scene*()>(),
                            "create",&Scene::create,
                            "createWithPhysics", &Scene::createWithPhysics,
                            "setOnEnterCallback", &Node::setOnEnterCallback,
                            sol::base_classes, sol::bases<Node>()
                                        );
#pragma endregion Scene


#pragma region AnimationCache
     CC.new_usertype<AnimationCache>("AnimationCache",
                                     "getInstance", &AnimationCache::getInstance);
#pragma endregion AnimationCache


#pragma region Node
     auto node_tb = CC.new_usertype<Node>("Node",
                           "create", &Node::create,
                           "addChild", sol::overload(sol::resolve<void(Node*)>(&Node::addChild)),
                                        sol::overload(sol::resolve<void(Node*, int)>(&Node::addChild)),
                                        sol::overload(sol::resolve<void(Node*, int, int)>(&Node::addChild)),
                           "removeFromParentAndCleanup", &Node::removeFromParentAndCleanup,
                           "removeFromParent", &Node::removeFromParent,
                           "setContentSize", &Node::setContentSize,
                           "getContentSize", &Node::getContentSize,
                           "getEventDispatcher", &Node::getEventDispatcher,
                           "getPositionX", &Node::getPositionX,
                           "getPositionY", &Node::getPositionY,
                           "setPositionX", &Node::setPositionX,
                           "setPositionY", &Node::setPositionY,
                           "getBoundingBox", &Node::getBoundingBox,
                           "convertToNodeSpaceAR", &Node::convertToNodeSpaceAR,
                           "convertToNodeSpace", &Node::convertToNodeSpace,
                           "convertToWorldSpace", &Node::convertToWorldSpace,
                           "convertToWorldSpaceAR", &Node::convertToWorldSpaceAR,
                           "convertTouchToNodeSpace", &Node::convertTouchToNodeSpace,
                           "setAnchorPoint", &Node::setAnchorPoint,
                           "getAnchorPoint", &Node::getAnchorPoint,
                           "isVisible", &Node::isVisible,
                           "setVisible", &Node::setVisible,
                           "setColor", &Node::setColor,
                           "getScale", &Node::getScale,
                           "setScale", sol::overload(sol::resolve<void(float )>(&Node::setScale)),
                           "getParent", sol::overload(sol::resolve<Node*()>(&Node::getParent)),
                           "setOnEnterCallback", &Node::setOnEnterCallback
                           );
//     node_tb.set_function("setOnEnterCallback", &Node::setOnEnterCallback);

#pragma endregion Node


#pragma region DrawNode
        CC.new_usertype<DrawNode>("DrawNode",
                                  sol::base_classes, sol::bases<Node>(),
                                  "create", &DrawNode::create,
                                  "drawCubicBezier", &DrawNode::drawCubicBezier,
                                  "draw", &DrawNode::draw,
                                  "drawDot", &DrawNode::drawDot,
                                  "drawLine", &DrawNode::drawLine,
                                  "drawPoint", &DrawNode::drawPoint,
                                  "drawQuadBezier", &DrawNode::drawQuadBezier,
                                  "clear", &DrawNode::clear
                                 );


#pragma endregion DrawNode


#pragma region LayerColor
     auto layer_tb = CC.new_usertype<LayerColor>("LayerColor",
                                 sol::base_classes, sol::bases<Node>()
                                 );

     layer_tb.set_function("create", sol::overload(
             sol::resolve<LayerColor*(const Color4B&)>(&LayerColor::create),
             sol::resolve<LayerColor*(const Color4B& , GLfloat, GLfloat)>(&LayerColor::create)
             ));
#pragma endregion LayerColor


#pragma region Sprite
     auto sp_tb =CC.new_usertype<Sprite>("Sprite",
                                        sol::base_classes, sol::bases<Node>()
                                       );
     sp_tb.set_function("create", sol::overload(
             sol::resolve<Sprite*()>(&Sprite::create),
             sol::resolve<Sprite*(const std::string&)>(&Sprite::create),
             sol::resolve<Sprite*(const std::string&, const cocos2d::Rect &)>(&Sprite::create)
             ));

     sp_tb.set_function("createWithTexture",
                        sol::overload(
                                sol::resolve<Sprite*(Texture2D*)>(&Sprite::createWithTexture),
                                sol::resolve<Sprite*(Texture2D*, const cocos2d::Rect&, bool)>(&Sprite::createWithTexture)));



#pragma endregion Sprite


#pragma region Label
    CC.new_usertype<Label>("Label",
                           "create", sol::overload(sol::resolve<Label*()>(&Label::create)),
                           "createWithTTF", sol::overload(sol::resolve<Label*(const std::string& text, const std::string& fontFile, float fontSize)>(createWithTTF)),
                           sol::base_classes, sol::bases<Node>(),
                           "setString", &Label::setString,
                           "setColor", &Label::setColor
                           );
#pragma endregion Label


#pragma region Event

     CC.new_usertype<EventDispatcher>("EventDispatcher",
                                      "addCustomEventListener", &EventDispatcher::addCustomEventListener,
                                      "addEventListenerWithSceneGraphPriority", &EventDispatcher::addEventListenerWithSceneGraphPriority,
                                      "addEventListenerWithFixedPriority",&EventDispatcher::addEventListenerWithFixedPriority
                                     );

     CC.new_usertype<EventListenerTouchOneByOne>("EventListenerTouchOneByOne",
                                          "create", &EventListenerTouchOneByOne::create,
                                          "setSwallowTouches", &EventListenerTouchOneByOne::setSwallowTouches,
                                          "isSwallowTouches", &EventListenerTouchOneByOne::isSwallowTouches,
                                          "onTouchBegan", &EventListenerTouchOneByOne::onTouchBegan,
                                          "onTouchMoved", &EventListenerTouchOneByOne::onTouchMoved,
                                          "onTouchEnded", &EventListenerTouchOneByOne::onTouchEnded,
                                          "onTouchCancelled", &EventListenerTouchOneByOne::onTouchCancelled,
                                          sol::base_classes, sol::bases<EventListener>()
                                          );


     CC.new_usertype<EventListenerMouse>("EventListenerMouse",
                                          "create", &EventListenerMouse::create,
                                          "onMouseDown", &EventListenerMouse::onMouseDown,
                                          "onMouseMove", &EventListenerMouse::onMouseMove,
                                          "onMouseUp", &EventListenerMouse::onMouseUp,
                                          "onMouseScroll", &EventListenerMouse::onMouseScroll,
                                          sol::base_classes, sol::bases<EventListener>()
                                          );

     CC.new_usertype<EventMouse>("EventMouse",
                                 "getMouseButton",&EventMouse::getMouseButton,
                                 "getLocation",&EventMouse::getLocation,
                                 "getStartLocation", &EventMouse::getStartLocation,
                                 "getScrollX", &EventMouse::getScrollX,
                                 "getScrollY", &EventMouse::getScrollY
     );

     CC.new_usertype<Touch>("Touch",
                                 "getLocation",&Touch::getLocation,
                                 "getStartLocation", &Touch::getStartLocation
     );

     CC.new_usertype<Event>("Event",
                                 "getCurrentTarget",&Event::getCurrentTarget
     );

     CC.new_usertype<EventListenerCustom>("EventListenerCustom",
                                          "create", &EventListenerCustom::create);

     auto kv_event = CC.new_usertype<EventListenerKeyboard>("EventListenerKeyboard",
                                    "create", &EventListenerKeyboard::create,
                                    sol::base_classes, sol::bases<EventListener>());
     kv_event["onKeyPressed"] = &EventListenerKeyboard::onKeyPressed;
     kv_event["onKeyReleased"] = &EventListenerKeyboard::onKeyReleased;

#pragma endregion Event


#pragma region Texture2D
//     CC.new_usertype<Texture2D>("Texture2D",
//                                "setTexParameters", &Texture2D::setTexParameters);
#pragma endregion Texture2D


#pragma region TextureCache
//     CC.new_usertype<TextureCache>("TextureCache",
//                                   "removeTextureForKey", &TextureCache::removeTextureForKey,
//                                   "getTextureForKey", &TextureCache::getTextureForKey,
//                                   "addImage", &TextureCache::addImage,
//                                   "addImageAsync", &TextureCache::addImageAsync);
#pragma endregion TextureCache

}
}
#endif

