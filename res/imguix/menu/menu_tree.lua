local Lang = require("lib/language/Lang")
local enum = require("enum")
local DataManager = require("data/datamanager")
local ViewManager = require("render/viewmanager")

-- node菜单
local tabNodeTree = {
    data = {
        _isShow = false,
        _posX = 0,
        _posY = 50,
        _btnIndex = 0,
    },
}

--显示菜单
function tabNodeTree:show(args)
    --print("显示 tabNodeTree")
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
            self.data._posY = 50
        end
    end
end
--隐藏菜单
function tabNodeTree:hide()
    --print("隐藏 tabNodeTree")
    self.data._isShow = false
end

-- 是否在显示
function tabNodeTree:isShow()
    return self.data._isShow
end
function tabNodeTree:addIndex()
    tabNodeTree._btnIndex = tabNodeTree._btnIndex + 1
end
function tabNodeTree:addBtn(uuid)
    self:addIndex()
    if ImGui.RadioButton("##" .. tabNodeTree._btnIndex, true) then
        ViewManager:toCenterForId(uuid)
    end
    ImGui.SameLine()
end

function tabNodeTree:addTree(dataBase)
    local uuid = dataBase:getuuid()
    if uuid then
        self:addBtn(dataBase:getuuid())
        local childList = dataBase:getChildIdList()
        if #childList > 0 then
            -- 排序
            DataManager:sortChild(childList)

            if ImGui.TreeNodeEx(dataBase:getName() .. "##" .. tabNodeTree._btnIndex, ImGui.ImGuiTreeNodeFlags.DefaultOpen, dataBase:getName()) then
                for i, v in ipairs(childList) do
                    local id = v.id
                    if id then
                        local dataTemp = DataManager:getDataForId(id)
                        if dataTemp then
                            self:addTree(dataTemp)
                        end
                    end
                end
                ImGui.TreePop()
            end
        else
            self:addIndex()
            if ImGui.MenuItem(dataBase:getName() .. "##" .. tabNodeTree._btnIndex) then
                print(uuid)
            end
        end
    end
end

function tabNodeTree.render()
    if tabNodeTree.data._isShow then
        tabNodeTree._btnIndex = 0

        ImGui.SetNextWindowPos(tabNodeTree.data._posX, tabNodeTree.data._posY, ImGui.ImGuiCond.Once)
        ImGui.Begin("NodeTree")

        for i, v in pairs(DataManager:getList()) do
            if #v:getParentIdList() <= 0 then
                tabNodeTree:addTree(v)
            end
        end

        ImGui.End()
    end

end

if ImGuiDraw then
    print("注册 tabNodeTree")
    ImGuiDraw(tabNodeTree.render)
end

return tabNodeTree