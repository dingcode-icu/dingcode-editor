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
    --tabMenuNode.data._isShow = true
    if tabMenuNode.data._isShow then
        ImGui.SetNextWindowPos(tabMenuNode.data._posX, tabMenuNode.data._posY, ImGui.ImGuiCond.Always)
        ImGui.Begin(Lang:Lang("menu_node", "node"), true, ImGui.ImGuiWindowFlags.NoTitleBar)

        -- 新建组合节点
        if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_composites")) then

            if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_sequence"), "") then
                local data = DataManager:createData(enum.logic_node_type.sequence)
                if data then
                    ViewManager:createNode(data)
                end
            end

            if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_selector"), "") then
                local data = DataManager:createData(enum.logic_node_type.selector)
                if data then
                    ViewManager:createNode(data)
                end
            end

            if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_parallel"), "") then
                local data = DataManager:createData(enum.logic_node_type.parallel)
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

            -- node
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_action_node")) then
                tabMenuNode.renderComNode()
                ImGui.EndMenu()
            end
            -- sprite
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_action_sprite")) then
                tabMenuNode.renderComNode()
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_sprite_path"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_sprite_path)
                    if data then ViewManager:createNode(data) end
                end
                ImGui.EndMenu()
            end
            -- lab
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_action_lab")) then
                tabMenuNode.renderComNode()
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_lab_string"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_lab_string)
                    if data then ViewManager:createNode(data) end
                end
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_lab_fontsize"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_lab_fontsize)
                    if data then ViewManager:createNode(data) end
                end
                ImGui.EndMenu()
            end
            -- richtext
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_action_richtext")) then
                tabMenuNode.renderComNode()
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_richtext_string"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_richtext_string)
                    if data then ViewManager:createNode(data) end
                end
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_richtext_fontsize"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_richtext_fontsize)
                    if data then ViewManager:createNode(data) end
                end
                ImGui.EndMenu()
            end
            --spine
            if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode_action_spine")) then
                tabMenuNode.renderComNode()
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_spine_animation"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_spine_animation)
                    if data then ViewManager:createNode(data) end
                end
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_spine_loop"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_spine_loop)
                    if data then ViewManager:createNode(data) end
                end
                if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_spine_timescale"), "") then
                    local data = DataManager:createData(enum.logic_node_type.action_spine_timescale)
                    if data then ViewManager:createNode(data) end
                end
                ImGui.EndMenu()
            end

            ImGui.EndMenu()
        end

        ImGui.End()
    end
end

function tabMenuNode.renderComNode()
    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_node_active"), "") then
        local data = DataManager:createData(enum.logic_node_type.action_node_active)
        if data then ViewManager:createNode(data) end
    end
    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_node_pos"), "") then
        local data = DataManager:createData(enum.logic_node_type.action_node_pos)
        if data then ViewManager:createNode(data) end
    end
    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_node_scale"), "") then
        local data = DataManager:createData(enum.logic_node_type.action_node_scale)
        if data then ViewManager:createNode(data) end
    end
    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_node_anchor"), "") then
        local data = DataManager:createData(enum.logic_node_type.action_node_anchor)
        if data then ViewManager:createNode(data) end
    end
    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_node_size"), "") then
        local data = DataManager:createData(enum.logic_node_type.action_node_size)
        if data then ViewManager:createNode(data) end
    end
    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_node_color"), "") then
        local data = DataManager:createData(enum.logic_node_type.action_node_color)
        if data then ViewManager:createNode(data) end
    end
    if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_action_node_alpha"), "") then
        local data = DataManager:createData(enum.logic_node_type.action_node_alpha)
        if data then ViewManager:createNode(data) end
    end
end

if ImGuiDraw then
    print("注册 tabMenuNode")
    ImGuiDraw(tabMenuNode.render)
end

return tabMenuNode
