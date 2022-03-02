local Event = require("res/lib/event")
local render = {}

function render:init()
    local dispatcher = cc.Director:getInstance():getEventDispatcher()

    local kb_evt = cc.EventListenerKeyboard:create();
    kb_evt["onKeyReleased"] = function(keycode, event)
        if keycode == cc.KeyBoardCode.KEY_DELETE or keycode == cc.KeyBoardCode.KEY_KP_DELETE then
            -- 删除按钮
            Event:dispatchEvent({
                name = enum.eventconst.imgui_delete_node,
            })
        end
    end
    dispatcher:addEventListenerWithFixedPriority(kb_evt, 10);
    self:__reload_src()
end

function render:__reload_src()
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