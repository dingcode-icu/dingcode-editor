local imguiUI = {
    _drawList = {},
    _isInitRoot = false,   --所有cocos渲染根节点是否初始化,
    _isDemo = false
}

function ImGuiRenderer()
    try {
        function()
            if not _isDemo then
                _isDemo = true
                table.insert(imguiUI._drawList, #imguiUI._drawList, ding.dev.show_imgui_demo)
            end
            if not _isInitRoot then
                _isInitRoot = true
                local ViewManager = require("res/render/viewmanager")
                ViewManager:initViewParent()
            end


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