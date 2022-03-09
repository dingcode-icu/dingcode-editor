local render = {}
local MEMORY = MEMORY

local Event = require("res/lib/event")
local ViewManager = require("res/render/viewmanager")

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
    }
}

---cocos渲染层初始化
-- @return nil
function render:init()
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
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
        if keycode == cc.KeyBoardCode.KEY_LEFT_CTRL or keycode == cc.KeyBoardCode.KEY_RIGHT_CTRL then
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
            if evt[keycode] then
                 Event:dispatchEvent({
                                    name = evt,
                                    data = data
                                })
            end
        end

        -- 是否按下 ctrl
        if keycode == cc.KeyBoardCode.KEY_LEFT_CTRL or keycode == cc.KeyBoardCode.KEY_RIGHT_CTRL then
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