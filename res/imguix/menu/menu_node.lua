local Lang = require("res/lib/language/Lang")
local DataManager = require("res/data/datamanager")
local ViewManager = require("res/render/viewmanager")
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
    if tabMenuNode.data._isShow then
        ImGui.Begin(Lang:Lang("menu_node", "node"))
        ImGui.SetWindowPos(tabMenuNode.data._posX, tabMenuNode.data._posY, ImGui.ImGuiCond.Always)
        if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode")) then
            -- 新建组合节点
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_composites")) then

                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_sequence"), "") then
                    local data = DataManager:createData(enum.nodetype.sequence)
                    if data then
                        ViewManager:createNode(data)
                    end
                end

                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_selector"), "") then
                    local data = DataManager:createData(enum.nodetype.selector)
                    if data then
                        ViewManager:createNode(data)
                    end
                end

                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_parallel"), "") then
                    local data = DataManager:createData(enum.nodetype.parallel)
                    if data then
                        ViewManager:createNode(data)
                    end
                end

                ImGui.EndMenu()
            end
            -- 新建修饰节点
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_decorator")) then


                ImGui.EndMenu()
            end
            -- 新建条件节点
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_conditinals")) then


                ImGui.EndMenu()
            end
            -- 新建行为节点
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_action")) then
                for i = 1, 60 do
                    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_sequence"), "") then end
                end

                ImGui.EndMenu()
            end

            ImGui.EndMenu()
        end

        if ImGui.MenuItem(Lang:Lang("menu_node", "close"), "") then
            tabMenuNode:hide()
        end

        ImGui.End()
    end
end

if ImGuiDraw then
    print("注册 tabMenuNode")
    ImGuiDraw(tabMenuNode.render)
end

return tabMenuNode
