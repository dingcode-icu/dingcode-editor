local Lang = require("res/lib/language/Lang")


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
    print("显示 tabMenuNode")
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
    print("隐藏 tabMenuNode")
    self.data._isShow = false
end

function tabMenuNode.render()
    if tabMenuNode.data._isShow then
        ImGui.Begin(Lang:Lang("menu_node", "node"))
        ImGui.SetWindowPos(tabMenuNode.data._posX, tabMenuNode.data._posY, ImGui.ImGuiCond.Always)
        if ImGui.BeginMenu(Lang:Lang("menu_node", "addnode")) then

            if ImGui.MenuItem(Lang:Lang("menu_node", "addnode_audio"), "") then
                print("click addnode_audio ")
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
