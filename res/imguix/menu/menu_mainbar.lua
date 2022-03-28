local Lang = require("lib/language/Lang")
local Event = require("lib/event")
local json = require("lib/json")
local DataManager = require("data/datamanager")
local ViewManager = require("render/viewmanager")
local imguix = require("imguix")

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

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "new"), "") then
                    tabMenuMainBar:SaveFile(true)
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "import"), "") then
                    tabMenuMainBar:OpenFile()
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "export"), "") then
                    tabMenuMainBar:SaveFile()
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "save"), "ctrl+S") then
                    tabMenuMainBar:AutoSaveFile()
                end

                if ImGui.MenuItem(Lang:Lang("menu_mainbar", "quit"), "ctrl+Q") then
                    ViewManager:exitGame()
                end

                ImGui.EndMenu()
            end

            if ImGui.BeginMenu(Lang:Lang("menu_mainbar", "setting")) then
                if ImGui.MenuItem("树形结构") then
                    Event:dispatchEvent({
                        name = enum.evt_keyboard.imgui_menu_tree,
                        isReversedSelect = true,
                    })
                end
                ImGui.EndMenu()
            end
            if ImGui.BeginMenu("调试") then
                if ImGui.MenuItem("重置") then
                    DataManager:reset()
                    ViewManager:reset()
                end
                if ImGui.MenuItem("打印 viewList") then
                    for i, v in pairs(ViewManager.data.viewList) do
                        print(v.data:getuuid())
                    end
                end
                if ImGui.MenuItem("打印 dataList") then
                    dump(DataManager.data, nil, 8)
                end

                if ImGui.MenuItem("初始化parent节点") then

                    try {
                        function()
                        end, catch {
                            function (err)
                                print(err)
                            end
                        }
                    }

                end

                if ImGui.MenuItem("showDemo") then
                    print("test aaaaaa")
                    imguix:open_demo()
                end

                if ImGui.MenuItem("showTip") then
                    ding.showToast("message")
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
    self:OpenFileForPath(filePath)
end

function tabMenuMainBar:OpenFileForPath(filePath)
    if filePath and string.len(filePath) > 0 and string.ends(filePath, ".ding") then
        local strDesc = io.readfile(filePath)
        try {
            function()

                local jsonData = json.decode(strDesc)
                print("============= open file")

                -- 打开之前 先还原
                DataManager:reset()
                ViewManager:reset()

                DataManager:init(jsonData)
                -- 设置保存的路径
                ViewManager:setSaveFilePath(filePath)

                -- 保存路径到 下次打开的菜单
                local fileutils = require("imguix/fileutils")
                fileutils:addMenuPathToList(filePath)
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
function tabMenuMainBar:SaveFile(isNew)
    local filePath = ding.FileDialogUtils.GetSaveFile()
    print(filePath)
    if filePath and string.len(filePath) > 0 then
        local realFilePath = filePath
        if not string.ends(filePath, ".ding") then
             realFilePath = filePath .. ".ding"
        end
        try {
            function()
                if isNew then
                    -- 如果是新建 重置数据
                    DataManager:reset()
                    ViewManager:reset()
                end
                local dataToSave = DataManager:get_alldata()
                local viewToSave = ViewManager:get_alldata()
                local treeToSave = DataManager:get_export_tree()
                local strData =  json.encode({
                    data = dataToSave,
                    view = viewToSave,
                    tree = treeToSave,
                })
                print("========== save file")
                --print(strData)
                local strDesc = io.writefile(realFilePath, strData)
                -- 设置保存的路径
                ViewManager:setSaveFilePath(realFilePath)

                -- 保存路径到 下次打开的菜单
                local fileutils = require("imguix/fileutils")
                fileutils:addMenuPathToList(realFilePath)

            end, catch {
                function (err)
                    print("保存文件出现错误")
                    print(err)
                end
            }
        }

    end

end

function tabMenuMainBar:AutoSaveFile()
    local realFilePath = ViewManager:getSaveFilePath()
    if realFilePath and string.len(realFilePath) > 0 then
        local dataToSave = DataManager:get_alldata()
        local viewToSave = ViewManager:get_alldata()
        local treeToSave = DataManager:get_export_tree()
        local strData =  json.encode({
            data = dataToSave,
            view = viewToSave,
            tree = treeToSave,
        })
        print("========== save file")
        --print(strData)
        local strDesc = io.writefile(realFilePath, strData)
        -- 设置保存的路径
        ViewManager:setSaveFilePath(realFilePath)
    else
        print("error tabMenuMainBar:AutoSaveFile 路径不存在")
    end
end


if ImGuiDraw then
    print("注册 tabMenuMainBar")
    ImGuiDraw(tabMenuMainBar.render)
end


return tabMenuMainBar
