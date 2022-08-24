local Lang = require("lib/language/Lang")
local enum = require("enum")

-- node菜单
local tabScreenSup = {
    data = {
        _isShow = false,
        _posX = 100,
        _posY = 100,

    },
}

--显示菜单
function tabScreenSup:show(args)
    --print("显示 tabScreenSup")
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
function tabScreenSup:hide()
    --print("隐藏 tabScreenSup")
    self.data._isShow = false

end

-- 是否在显示
function tabScreenSup:isShow()
    return self.data._isShow
end

function tabScreenSup.render()
    if tabScreenSup.data._isShow then
        ImGui.SetNextWindowPos(tabScreenSup.data._posX, tabScreenSup.data._posY, ImGui.ImGuiCond.Always)
        ImGui.SetNextWindowSize(800, 300, ImGui.ImGuiCond.Once)
        ImGui.Begin("tabScreenSup", true, ImGui.ImGuiWindowFlags.NoTitleBar)

        ImGui.Text("筛选要显示的节点类型")
        ImGui.Separator()

        if enum.show_suppose_type then
            for i, v in pairs(enum.show_suppose_type) do
                enum.show_suppose_type[i] = ImGui.Checkbox(i, enum.show_suppose_type[i]);
            end
        end



        ImGui.Separator()
        if (ImGui.Button("OK")) then
            tabScreenSup:hide()
        end

        ImGui.End()
    end

end

if ImGuiDraw then
    print("注册 tabScreenSup")
    ImGuiDraw(tabScreenSup.render)
end

return tabScreenSup