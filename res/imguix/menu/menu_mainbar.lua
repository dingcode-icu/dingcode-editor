local Lang = require("lib/language/Lang")
local Event = require("lib/event")
local json = require("lib/json")
local DataManager = require("data/datamanager")
local ViewManager = require("render/viewmanager")
local imguix = require("imguix")
local conf = require("imguix/config/conf_menu")
local Api = require("http/api")
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
    --调试菜单
    local function append_debug()
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
                        function(err)
                            print(err)
                        end
                    }
                }

            end

            if ImGui.MenuItem("showDemo") then
                print("test aaaaaa")
                imguix:open_demo()
            end

            if ImGui.MenuItem("showToast") then
                ding.showToast("message")
            end
            if ImGui.MenuItem("showTip") then
                ViewManager:showTip("message")
            end

            ImGui.EndMenu()
        end

    end
    --菜单响应事件
    local func_map = {
        --file
        new = c_func(tabMenuMainBar, tabMenuMainBar.SaveFile, true),
        import = c_func(tabMenuMainBar, tabMenuMainBar.OpenFile),
        export = c_func(tabMenuMainBar, tabMenuMainBar.SaveFile),
        save = c_func(tabMenuMainBar, tabMenuMainBar.AutoSaveFile),
        quite = c_func(ViewManager, ViewManager.exitGame),
        --view
        show_treenodes = function()
            Event:dispatchEvent({
                name = enum.evt_keyboard.imgui_menu_tree,
                isReversedSelect = true,
            })

        end,
        show_node_info = function()
            Event:dispatchEvent({
                name = enum.evt_keyboard.imgui_menu_detail,
                isReversedSelect = true,
            })
        end,
        --node
        add_node = function()
                print("show addnode")
             Event:dispatchEvent({
                name = enum.evt_keyboard.imgui_popup_addnode,
                isReversedSelect = true,
            })
        end,
        fetch_node = function()
            Api:initConfig()
        end
    }
    --插入子菜单
    local function insert_child(children)
        for _, c in ipairs(children) do
            if (ImGui.MenuItem(Lang:Lang("menu_mainbar", c["ln_key"]))) then
                local func = func_map[c["title"]]
                if func then
                    func()
                else
                    print("[error]not func menu func to execute!")
                end
            end
        end
    end

    local conf_mainmenu = conf["menu_main"]
    if tabMenuMainBar.data._isShow then
        if ImGui.BeginMainMenuBar() then
            for _, v in ipairs(conf_mainmenu) do
                if ImGui.BeginMenu(Lang:Lang("menu_mainbar", v["ln_key"])) then
                    if type(v["children"]) == "table" then
                        insert_child(v["children"])
                    end
                    ImGui.EndMenu()
                end
            end
            append_debug()
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
    if filePath and string.len(filePath) > 0 and string.ends(filePath, ".ding.json") then
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

                ViewManager:showTip("打开成功, " .. filePath)
            end, catch {
                function()
                    print("请选择正确的配置文件")
                    ViewManager:showTip("请选择正确的配置文件")
                end
            }
        }

    else
        print("文件 不是 配置文件")
        ViewManager:showTip("所选文件不是配置文件")
    end
end

-- 保存文件
function tabMenuMainBar:SaveFile(isNew)
    local filePath = ding.FileDialogUtils.GetSaveFile()
    print(filePath)
    if filePath and string.len(filePath) > 0 then
        local realFilePath = filePath
        if not string.ends(filePath, ".ding.json") then
            realFilePath = filePath .. ".ding.json"
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
                local strData = json.encode({
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

                ViewManager:showTip("保存文件成功")

            end, catch {
                function(err)
                    print("保存文件出现错误")
                    print(err)
                    ViewManager:showTip("保存文件出错")
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
        local strData = json.encode({
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
        ViewManager:showTip("保存文件失败 请点击菜单保存")
    end
end

if ImGuiDraw then
    print("注册 tabMenuMainBar")
    ImGuiDraw(tabMenuMainBar.render)
end

return tabMenuMainBar
