local Lang = require("res/lib/language/Lang")
local Event = require("res/lib/event")
local json = require("res/lib/json")
local DataManager = require("res/data/datamanager")
local ViewManager = require("res/render/viewmanager")

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
-- 是否在显示
function tabMenuMainBar:isShow()
    return self.data._isShow
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
                            name = enum.evt_keyboard.imgui_menu_node,
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
            if ImGui.BeginMenu("调试") then
                if ImGui.MenuItem("打印 viewList") then
                    for i, v in pairs(ViewManager.data.viewList) do
                        print(v.data:getuuid())
                    end
                end
                if ImGui.MenuItem("打印 dataList") then
                    dump(DataManager.data)
                end

                if ImGui.MenuItem("初始化parent节点") then

                    try {
                        function()
                            --ViewManager:initViewParent()
                        end, catch {
                            function (err)
                                print(err)
                            end
                        }
                    }


                end
                ImGui.EndMenu()
            end



            ImGui.EndMainMenuBar()
        end

    end
end

-- 打开文件
function tabMenuMainBar:OpenFile()
    dump(ding, "-->>ding")
    local filePath = ding.FileDialogUtils.GetOpenFile()
    print(filePath)
    if filePath and string.len(filePath) > 0 and string.ends(filePath, ".ding") then
        local strDesc = io.readfile(filePath)

        try {
            function()
                local jsonData = json.decode(strDesc)
                print("============= open file")

                DataManager:init(jsonData)
            end, catch {
                function ()
                    print("请选择正确的配置文件")
                end
            }
        }

    else
        print("文件 不是 配置文件")
    end
end

-- 保存文件
function tabMenuMainBar:SaveFile()
    local filePath = ding.FileDialogUtils.GetSaveFile()
    print(filePath)
    if filePath and string.len(filePath) > 0 then
        local realFilePath = filePath
        if not string.ends(filePath, ".ding") then
             realFilePath = filePath .. ".ding"
        end
        try {
            function()
                local data = DataManager:get_alldata()
                local strData =  json.encode(data)
                print("========== save file")
                --print(strData)
                local strDesc = io.writefile(realFilePath, strData)
            end, catch {
                function ()
                    print("保存文件出现错误")
                end
            }
        }

    end

end


if ImGuiDraw then
    print("注册 tabMenuMainBar")
    ImGuiDraw(tabMenuMainBar.render)
end


return tabMenuMainBar
