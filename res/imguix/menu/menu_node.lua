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

        local listType = enum.enum_node_type
        for _, strType in pairs(listType) do
            local list = enum.logic_node_list[strType]

            if ImGui.BeginMenu(strType) then
                if type(list) =="table" then
                    for i, name in pairs(list) do
                        local data = enum.logic_node_type[strType][name]
                        local name = data.name
                        local desc = data.desc or ""
                        local supposeType = data.supposeType or ""
                        if enum.show_suppose_type and enum.show_suppose_type[supposeType] then
                            if ImGui.MenuItem(name, desc) then
                                local dataTemp = DataManager:createData(data)
                                if dataTemp then
                                    ViewManager:createNode(dataTemp)
                                end
                            end
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
