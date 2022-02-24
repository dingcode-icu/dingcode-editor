local render = {}

function render:init()
    local dispatcher = cc.Director:getInstance():getEventDispatcher()

    local kb_evt = cc.EventListenerKeyboard:create();
    kb_evt["onKeyReleased"] = function()
        print("test")
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