local Lang = require("lib/language/Lang")
local enum = require("enum")
local DataManager = require("data/datamanager")
local ViewManager = require("render/viewmanager")

-- node菜单
local tabNodeDetail = {
    data = {
        _isShow = false,
        _posX = 0,
        _posY = 50,
        _btnIndex = 0,
        _uuid = nil,                -- 需要展示的item uuid 列表
    },
}

--显示菜单
function tabNodeDetail:show(args)
    --print("显示 tabNodeDetail")
    self.data._isShow = true
    self:refresh(args)
end
function tabNodeDetail:refresh(args)
    if args then
        if args.posX then
            self.data._posX = args.posX
        else
            self.data._posX = 0
        end
        if args.posY then
            self.data._posY = args.posY
        else
            self.data._posY = 50
        end
        if args.uuid then
            self.data._uuid = args.uuid
        else
            self.data._uuid = nil
        end
    end
end
--隐藏菜单
function tabNodeDetail:hide()
    --print("隐藏 tabNodeDetail")
    self.data._isShow = false
    self.data._uuid = nil
end

-- 是否在显示
function tabNodeDetail:isShow()
    return self.data._isShow
end

function tabNodeDetail.render()
    if tabNodeDetail.data._isShow then
        tabNodeDetail._btnIndex = 0

        ImGui.SetNextWindowPos(tabNodeDetail.data._posX, tabNodeDetail.data._posY, ImGui.ImGuiCond.Once)
        ImGui.SetNextWindowSize(300, 600, ImGui.ImGuiCond.Once)
        ImGui.Begin("NodeDetail")

        if tabNodeDetail.data._uuid then
            local data = DataManager:getDataForId(tabNodeDetail.data._uuid)
            if data then
                -- desc
                ImGui.Text("desc: ");
                ImGui.SameLine()
                ImGui.Text(data:getDesc());
                -- type
                ImGui.Text("type: ");
                ImGui.SameLine()
                ImGui.Text(data:gettype());
                -- name
                ImGui.Text("name: ");
                ImGui.SameLine()
                ImGui.Text(data:getName());
                -- uuid
                ImGui.Text("uuid: ");
                --ImGui.SameLine()
                ImGui.SetWindowFontScale(0.7)
                if ImGui.SmallButton(data:getuuid()) then
                    ViewManager:toCenterForId(data:getuuid())
                end
                ImGui.SetWindowFontScale(1)
                -- 分割线
                ImGui.Separator();


                -- 输入
                ImGui.Text("input: ");
                local listinput = data:getListInputConfig()
                if listinput then
                    for key, v in pairs(listinput) do
                        ImGui.Text(v.desc .. ": ");
                        local list = data:getListInputForId(key)
                        if list and #list > 0 then
                            for i, value in pairs(list) do
                                ImGui.Text("" .. value)
                            end
                        end
                    end
                end

                -- 分割线
                ImGui.Separator();

                -- 输出
                ImGui.Text("output: ");
                local listoutput = data:getListOutputConfig()
                if listoutput then
                    for key, v in pairs(listoutput) do
                        ImGui.Text(v.desc .. ": ");
                    end
                end

                -- 分割线
                ImGui.Separator();
            end
        end


        ImGui.End()
    end

end

if ImGuiDraw then
    print("注册 tabNodeDetail")
    ImGuiDraw(tabNodeDetail.render)
end

return tabNodeDetail