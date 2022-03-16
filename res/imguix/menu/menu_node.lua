local Lang = require("lib/language/Lang")
local DataManager = require("data/datamanager")
local ViewManager = require("render/viewmanager")
local enum = require("enum")

-- node菜单
local tabMenuNode = {
    data = {
        _isShow = false,
        _posX = 0,
        _posY = 0,
    }
}

--显示菜单
function tabMenuNode:show(args)
    --print("显示 tabMenuNode")
    self.data._isShow = true
    if args then
        if args.posX then
            self.data._posX = args.posX
        else
            self.data._posX = 0
        end
        if args.posY then
            self.data._posY = args.posY
        else
            self.data._posY = 0
        end
    end
end
--隐藏菜单
function tabMenuNode:hide()
    --print("隐藏 tabMenuNode")
    self.data._isShow = false
end
function tabMenuNode:getMenuPos()
    return {x = self.data._posX, y = self.data._posY}
end
-- 是否在显示
function tabMenuNode:isShow()
    return self.data._isShow
end

function tabMenuNode.render()
    --tabMenuNode.data._isShow = true
    if tabMenuNode.data._isShow then
        ImGui.SetNextWindowPos(tabMenuNode.data._posX, tabMenuNode.data._posY, ImGui.ImGuiCond.Always)
        ImGui.Begin(Lang:Lang("menu_node", "node"), true, ImGui.ImGuiWindowFlags.NoTitleBar)

        local listType = enum.list_node_type
        for indexlist, strType in pairs(listType) do
            local list = enum.logic_node_type[strType]
            if ImGui.BeginMenu(strType) then
                for i, name in pairs(enum.logic_node_list[strType]) do
                    local data = list[name]
                    local name = data.name
                    local desc = data.desc or ""
                    if ImGui.MenuItem(name, desc) then
                        local dataTemp = DataManager:createData(data)
                        if dataTemp then
                            ViewManager:createNode(dataTemp)
                        end
                    end
                end
                ImGui.EndMenu()
            end
        end

        ImGui.End()
    end
end

if ImGuiDraw then
    print("注册 tabMenuNode")
    ImGuiDraw(tabMenuNode.render)
end

return tabMenuNode
