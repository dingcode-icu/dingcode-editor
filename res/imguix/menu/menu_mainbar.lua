local Lang = require("res/lib/language/Lang")
local Event = require("res/lib/event")

--上方主菜单
local tabMenuMainBar = {
    data = {
        _isShow = false,
        _posX = 0,
        _posY = 0,
    }
}

--显示菜单
function tabMenuMainBar:show(args)
    print("显示 tabMenuMainBar")
    self.data._isShow = true
    if args then

    end
end

--隐藏菜单
function tabMenuMainBar:hide()
    print("隐藏 tabMenuMainBar")
    self.data._isShow = false
end

function tabMenuMainBar.render()
    if tabMenuMainBar.data._isShow then
        if ImGui.BeginMainMenuBar() then
            if ImGui.BeginMenu(Lang:Lang("menu_mainbar", "file")) then
                if ImGui.BeginMenu(Lang:Lang("menu_mainbar", "new")) then
                    if ImGui.MenuItem(Lang:Lang("menu_mainbar", "proj")) then
                        tabMenuMainBar:SaveFile()
                    end

                    if ImGui.MenuItem(Lang:Lang("menu_node", "node")) then
                        Event:dispatchEvent({
                            name = "imgui_menu_node",
                            posX = math.random() * 300 + 100,
                            posY = math.random() * 300 + 100,
                        })
                    end

                    ImGui.EndMenu()
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "import"), "") then
                    tabMenuMainBar:OpenFile()
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "export"), "") then
                    tabMenuMainBar:SaveFile()
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "save"), "ctrl+S") then
                    print("click save ")
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "quit"), "ctrl+Q") then
                    print("quit")
                end

                ImGui.EndMenu()
            end

            if ImGui.BeginMenu(Lang:Lang("menu_mainbar", "setting")) then
                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "settAudio")) then
                    print("click audio setting ")
                end
                ImGui.EndMenu()
            end
            ImGui.EndMainMenuBar()
        end

    end
end

-- 打开文件
function tabMenuMainBar:OpenFile()
    local filePath = ding.FileDialogUtils.GetOpenFile()
    print(filePath)
end

-- 保存文件
function tabMenuMainBar:SaveFile()
    local filePath = ding.FileDialogUtils.GetSaveFile()
    print(filePath)
end


if ImGuiDraw then
    print("注册 tabMenuMainBar")
    ImGuiDraw(tabMenuMainBar.render)
end


return tabMenuMainBar
