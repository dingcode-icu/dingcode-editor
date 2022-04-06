local render = {}

require("render/memory")
local Event = require("lib/event")
local ViewManager = require("render/viewmanager")
local MEMORY = MEMORY
local d = display
local dir_inc = cc.Director:getInstance()

---root scene
local root
do
root = class("RootScene")
function root:ctor()
    self.view = cc.Scene.create()
    self.view:setOnEnterCallback(function()
        render:init()
        ViewManager:initViewParent()
    end)
end
end
local sc = root.new()
dir_inc:runWithScene(sc.view)

---单按键键盘快捷键
local SINGLE_KEY_MAP  = {
    [cc.KeyBoardCode.KEY_DELETE] = enum.evt_keyboard.imgui_delete_node,
    [cc.KeyBoardCode.KEY_KP_DELETE] = enum.evt_keyboard.imgui_delete_node,
    [cc.KeyBoardCode.KEY_F5] = enum.evt_keyboard.dev_reload
}

---多按键键盘快捷键
local MULTI_KEY_MAP = {
    [cc.KeyBoardCode.KEY_LEFT_CTRL] = {
        [cc.KeyBoardCode.KEY_0] = enum.evt_keyboard.imgui_delete_node,
        [cc.KeyBoardCode.KEY_Q] = enum.evt_keyboard.sys_exit,
        [cc.KeyBoardCode.KEY_S] = enum.evt_keyboard.sys_autosave,
    },
    [cc.KeyBoardCode.KEY_HYPER] = {
        [cc.KeyBoardCode.KEY_0] = enum.evt_keyboard.imgui_delete_node,
        [cc.KeyBoardCode.KEY_Q] = enum.evt_keyboard.sys_exit,
        [cc.KeyBoardCode.KEY_S] = enum.evt_keyboard.sys_autosave,
    }
}

---cocos渲染层初始化
-- @return nil
function render:init()
    --init displayex 
    d.setDefFont("font/FZLanTYJW.TTF")

    local dispatcher = dir_inc:getEventDispatcher()
    local comb_cnt = 0
    local comb_key = nil
    local kb_evt = cc.EventListenerKeyboard:create();
    kb_evt["onKeyReleased"] = function(keycode, data)
        local evt = SINGLE_KEY_MAP[keycode]
        local mut_evt = MULTI_KEY_MAP[keycode]

        if evt then
            Event:dispatchEvent({
                    name = evt,
                    data = data
                })
        end
        if mut_evt then
            comb_cnt = comb_cnt - 1
            comb_key = nil
        end

        -- 是否按下 ctrl
        if keycode == cc.KeyBoardCode.KEY_LEFT_CTRL or keycode == cc.KeyBoardCode.KEY_RIGHT_CTRL or keycode == cc.KeyBoardCode.KEY_HYPER then
            MEMORY.isCtrlDown = false
            ViewManager:setAllNodeSwallowTouch(false)
        end
    end
    kb_evt["onKeyPressed"] = function(keycode, data)
        local evt = MULTI_KEY_MAP[keycode]
        if evt  then
            comb_cnt = comb_cnt + 1
            comb_key = keycode
        end
        if comb_cnt >=1 then
            if MULTI_KEY_MAP[comb_key] then
                if MULTI_KEY_MAP[comb_key][keycode] then
                     Event:dispatchEvent({
                                        name = MULTI_KEY_MAP[comb_key][keycode],
                                        data = data
                                    })
                end
            end
        end
        -- 是否按下 ctrl
        if keycode == cc.KeyBoardCode.KEY_LEFT_CTRL or keycode == cc.KeyBoardCode.KEY_RIGHT_CTRL or keycode == cc.KeyBoardCode.KEY_HYPER then
            MEMORY.isCtrlDown = true
            ViewManager:setAllNodeSwallowTouch(true)
        end
    end
    dispatcher:addEventListenerWithFixedPriority(kb_evt, 10);

    if RELEASE.IS_DEV_KEYBOARD then
        self:__dev()
    end
end


function render:__dev()
    Event:addEventListener(enum.evt_keyboard.dev_reload, handler(self, self.__reload_src))
end

--重载render下的脚本
function render:__reload_src()
    print("reload src")
    for i, v in pairs(package.loaded) do
        print(i, v, '_-..i, v')
        if i and
            string.find(i, "render")
        then
            package.loaded[i] = nil
            package.preload[i] = nil
        end
    end
end

return render