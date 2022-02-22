-- node菜单
local tabMenuNode = {
    data = {
        _isShow = true,
        _posX = 0,
        _posY = 0,
    }
}

--显示菜单
function tabMenuNode:show(args)
    print("显示 tabMenuNode")
    self.data._isShow = true
    if args then

    end
end

--隐藏菜单
function tabMenuNode:hide()
    print("隐藏 tabMenuNode")
    self.data._isShow = false
end

function tabMenuNode.render()
    if tabMenuNode.data._isShow then

    end
end

if ImGuiDraw then
    print("注册 tabMenuNode")
    ImGuiDraw(tabMenuNode.render)
end

return tabMenuNode
