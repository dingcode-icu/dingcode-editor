local imguiUI = {
    _drawList = {},
    _isInitRoot = false -- 所有cocos渲染根节点是否初始化,
}

function ImGuiRenderer()
    try {function()
        if RELEASE.IMGUI_DEBUG_MENU then
            print("_isdemo", _isDemo)
            imguiUI._isDemo = false
            table.insert(imguiUI._drawList, #imguiUI._drawList, ding.dev.show_imgui_demo)
        end
        if not imguiUI._isInitRoot then
            imguiUI._isInitRoot = true
        end

        for k, v in pairs(imguiUI._drawList) do
            if v then
                v()
            end
        end
    end, catch {function(err)
        print("err ImGuiRenderer")
        print(err)
    end}}

end

function ImGuiDraw(func)
    imguiUI._drawList[func] = func
end

function imguiUI:init()
    self._drawList = {}

    local Event = require("lib/event")
    Event:bind(self)

    require("imguix/menu/menu_all")
end

function imguiUI:open_demo()
    imguiUI._isDemo = true
end

return imguiUI
