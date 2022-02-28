local imguiUI = {
    _drawList = {}
}

function ImGuiRenderer()

    try {
        function()
            for k,v in pairs(imguiUI._drawList) do
                if v then v() end
            end
        end, catch {
            function (err)
                print("err ImGuiRenderer")
                print(err)
            end
        }
    }

end

function ImGuiDraw(func)
     imguiUI._drawList[func] = func
end

function imguiUI:init()
    self._drawList = {}

    local Event = require("res/lib/event")
    Event:bind(self)
end

return imguiUI