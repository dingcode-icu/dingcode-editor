local Lang = require("lib/language/Lang")
local enum = require("enum")

-- node菜单
local tabStartNode = {
    data = {
        _isShow = false,
        _posX = 200,
        _posY = 100,
        _finishFunc = nil,
        _typeinput = nil,
        _isInputed = false,
        _lab = nil,
        _isEnd = false,
    },
}

--显示菜单
function tabStartNode:show(args)
    --print("显示 tabStartNode")
    self.data._isShow = true
    if args then
        --if args.posX then
        --    self.data._posX = args.posX
        --else
        --    self.data._posX = 0
        --end
        --if args.posY then
        --    self.data._posY = args.posY
        --else
        --    self.data._posY = 0
        --end
    end
end
--隐藏菜单
function tabStartNode:hide()
    --print("隐藏 tabStartNode")
    self.data._isShow = false
end

-- 是否在显示
function tabStartNode:isShow()
    return self.data._isShow
end

function tabStartNode.render()
    if tabStartNode.data._isShow then
        ImGui.SetNextWindowPos(tabStartNode.data._posX, tabStartNode.data._posY, ImGui.ImGuiCond.Always)
        ImGui.Begin("tabStartNode", true, ImGui.ImGuiWindowFlags.NoTitleBar)

        ImGui.Text("请先新建/打开项目");
        ImGui.Separator();

        if ImGui.MenuItem("新建项目") then
            local menu_mainbar = require("imguix/menu/menu_mainbar")
            menu_mainbar:SaveFile(true)
        end

        if ImGui.MenuItem("打开项目") then
            local menu_mainbar = require("imguix/menu/menu_mainbar")
            menu_mainbar:OpenFile()
        end

        ImGui.Separator();
        ImGui.Text("快速打开： ");
        -- 本地已经打开过的菜单
        local fileutils = require("imguix/fileutils")
        local list = fileutils:getListMenuPath()
        for i, v in ipairs(list) do
            if string.len(v) > 0 then
                local strFile = v
                local listName = string.split(strFile, "/")
                if not ding.isMac() then
                    listName = string.split(strFile, "\\")
                end
                if ImGui.MenuItem(listName[#listName]) then
                    local menu_mainbar = require("imguix/menu/menu_mainbar")
                    menu_mainbar:OpenFileForPath(strFile)
                end
                ImGui.Text(strFile);
            end
        end

        ImGui.End()
    end

end

if ImGuiDraw then
    print("注册 tabStartNode")
    ImGuiDraw(tabStartNode.render)
end

return tabStartNode