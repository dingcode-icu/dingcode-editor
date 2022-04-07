local DataManager = require("data/datamanager")
local json = require("lib/json")
local Event = require("lib/event")
local enum = enum
local winWidth = cc.Director:getInstance():getWinSize().width
local winHeight = cc.Director:getInstance():getWinSize().height

local viewManager = {
    data = {
        viewList = {},                      -- 创建的数据
        lineList = {},                      -- 线
    },

    historylist = {},                       -- 历史记录 ctrl z 使用

    isInit = false,                         -- 是否已经初始化
    strsavefilepath = "",                   -- 打开/保存的文件路径

    isDropingLine = false,                  -- 是否正在拖动划线
    dataRropingLine = null,                 -- 拖动中的数据对象
    nodeDropingLine = null,                 -- 拖动中的对象
    _isAllNodeSwallow = false,

    isDropingNode = false,                  -- 是否正在拖动节点

    _viewParent = null,
    _lineParent = null,
    _tipParent = null,
}
---初始化root view场景
function viewManager:init(config, isNotResetHistory)
    if config and config.view then
        if config.view.viewList then
            for i, v in pairs(config.view.viewList) do
                local uuid = v.uuid
                local x = v.x
                local y = v.y
                local dataNode = DataManager:getDataForId(uuid)
                self:createNode(dataNode, { x = x, y = y}, isNotResetHistory)
            end
        end
        if config.view.lineList then
            for i, v in pairs(config.view.lineList) do
                local uuidStart = v.uuidStart
                local uuidEnd = v.uuidEnd
                local keyStart = v.keyStart
                local keyEnd = v.keyEnd
                local nodeStart = self:getNodeViewForId(uuidStart)
                local endNodeData = self:getNodeViewForId(uuidEnd)
                local posStart, dirIn = nodeStart:getDropPosForKey(keyStart)
                local posEnd, dirOut = endNodeData:getDropPosForKey(keyEnd)
                if posStart and posEnd then
                    local data = {
                        nodeDataStart = nodeStart,
                        nodeDataEnd = endNodeData,
                        keyStart = keyStart,
                        keyEnd = keyEnd,
                        dirOut = dirOut,
                        dirIn = dirIn,
                    }
                    local lineNode = self:createLineBezier(posStart, posEnd, data)
                    self.data.lineList[lineNode:getuuid()] = lineNode
                end
            end
        end
    end

    if not isNotResetHistory then
        self.historylist = {}
        self:addHistoryToList()
    end
    self:setIsInit(true)
    self.isDropingLine = false
    self.isDropingNode = false


end
-- 页面是否创建成功
function viewManager:getIsInit()
    if not self.isInit then
        --print("请先 创建or打开 工程")
    end
    return self.isInit
end
-- 设置 页面是否创建成功
function viewManager:setIsInit(isInit)
    self.isInit = isInit
    if isInit then
        Event:dispatchEvent({
            name = enum.evt_keyboard.imgui_menu_start,
            isHide = true,
        })
    end
end
-- 获取打开/自动保存的文件路径
function viewManager:getSaveFilePath()
    return self.strsavefilepath
end
-- 设置打开/自动保存的文件路径
function viewManager:setSaveFilePath(path)
    self.strsavefilepath = path
end
-- 根据id 获取页面上的显示节点
function viewManager:getNodeViewForId(uuid)
    return self.data.viewList[uuid]
end
-- 获取保存的数据
function viewManager:get_alldata()
    local real = {
        viewList = {},
        lineList = {},
    }
    for i, v in pairs(self.data.viewList) do
        local tempData = {
            uuid = v:getuuid(),
            x = v:getPositionX(),
            y = v:getPositionY(),
        }
        real.viewList[v:getuuid()] = tempData
    end
    for i, v in pairs(self.data.lineList) do
        local tempData = v:getDataToSave()
        real.lineList[v:getuuid()] = tempData
    end
    return real
end
--- 销毁root view场景
function viewManager:reset(isNotResetHistory)
    for i, v in pairs(self.data.viewList) do
        v:destroy()
    end
    for i, v in pairs(self.data.lineList) do
        v:destroy()
    end
    self.data.viewList = {}
    self.data.lineList = {}
    if not isNotResetHistory then
        self.historylist = {}
    end
    self.isDropingLine = false                  -- 是否正在拖动划线
    self.isDropingNode = false
    self.dataRropingLine = null                 -- 拖动中的数据对象
    self.nodeDropingLine = null                 -- 拖动中的对象
    self._isAllNodeSwallow = false

    self:setIsInit(true)
end

function viewManager:initViewParent()
    self:_initGraph()
    self:_regEvent()
end
function viewManager:_initGraph()
    local root = cc.Node.create()
    root:setContentSize(cc.size(10000,10000))
    self._viewParent = root

    local bg = ding.bgSprite("texture/grid.png", cc.rect(0, 0, display.width *100, display.height * 100))
    root:addChild(bg)
    root:setPositionX(display.width / 2)
    root:setPositionY(display.height / 2)

    local nodelineParent = cc.Node.create()
    self._viewParent:addChild(nodelineParent)
    self._lineParent = nodelineParent

    local scene = cc.Director:getInstance():getRunningScene()
    scene:addChild(root)

    self._tipParent = cc.Node.create()
    scene:addChild(self._tipParent)
end
function viewManager:_regEvent()
    self:registerTouch()
    self:registerEvent()
end
function viewManager:setAllNodeSwallowTouch(isSwallow)
    if self._isAllNodeSwallow == isSwallow then
        return
    end
    self._isAllNodeSwallow = isSwallow
    local list = self.data.viewList
    for i, v in pairs(list) do
        v:setSwallowTouches(isSwallow)
    end
end
function viewManager:registerTouch()
    local node = self._viewParent
    local this = self
    -- 注册 点击事件
    print("register event touch")
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true);
    listener.onTouchBegan = function()
        if not this:getIsInit() then
             return true
        end
        return true
    end
    listener.onTouchMoved = function(touch, event)
        if not this:getIsInit() then
             return true
        end
        if this.isDropingLine then
            this:upStartDropingline(touch:getLocation())
            return true
        end
        return false
    end
    listener.onTouchEnded = function(touch, event)
        if not this:getIsInit() then
             return true
        end
        --local mouseType = event:getButton()
        if this.isDropingLine then
            this:cancelDropingLine()
        end
        this:hide_imgui_menu_all()
        this:unSelectAll()
        print("viewmanager touch end")

        return true
    end
    listener.onTouchCancelled = function()
        if not this:getIsInit() then
             return true
        end
        --print("4")
        if this.isDropingLine then
            this:cancelDropingLine()
        end
        return true
    end
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node);
    -- 注册 右键点击
    local listener = cc.EventListenerMouse:create();
    listener.onMouseDown = function(event)
        if not this:getIsInit() then
             return true
        end
        local mouseType = event:getMouseButton()
        if mouseType == 1 and this._viewParent then
            this._mouseStart = event:getLocation()
            this._parPosStartX = this._viewParent:getPositionX()
            this._parPosStartY = this._viewParent:getPositionY()
        end
    end
    listener.onMouseMove = function(event)
        if not this:getIsInit() then
             return true
        end
        local mouseType = event:getMouseButton()
        if mouseType == 1 and this._viewParent then
            local pos = event:getLocation()
            local pStart = this._mouseStart
            this._viewParent:setPositionX(this._parPosStartX + pos.x - pStart.x)
            this._viewParent:setPositionY(this._parPosStartY - pos.y + pStart.y)
        end

    end
    listener.onMouseUp = function(event)
        if not this:getIsInit() then
             return true
        end
        local mouseType = event:getMouseButton()
        if mouseType == 0 then
            --print("左键点击")
            -- 关闭菜单会拦截菜单的点击
        elseif mouseType == 1 then
            -- print("右键点击")
            local pos = event:getLocation()
            local pStart = this._mouseStart
            if math.abs(pStart.x - pos.x) < 10 and math.abs(pStart.y - pos.y) < 10 then
                Event:dispatchEvent({
                    name = enum.evt_keyboard.imgui_menu_node,
                    posX = pos.x,
                    posY = pos.y,
                })
            end
        end
        return true
    end

    listener.onMouseScroll = function(event)
        if not this:getIsInit() then
             return true
        end
        local menu_node = require("imguix/menu/menu_node")
        --local menu_mainbar = require("imguix/menu/menu_mainbar")
        if menu_node:isShow() then
            return
        end
        -- 鼠标滚轮 缩放
        local scrollY = event:getScrollY()
        if this._viewParent then
            local size = this._viewParent:getContentSize()
            local posLocal = this._viewParent:convertToNodeSpace(event:getLocation())
            local posAnchor = cc.p(posLocal.x / size.width, (posLocal.y) / size.height)
            --print(posAnchor.x, posAnchor.y, posLocal.x, posLocal.y, size.width, size.height)
            this.setAnchorOnly(this._viewParent, posAnchor)
            

            local curScale = this._viewParent:getScale() + scrollY * 0.02
            if curScale < 0.3 then
                curScale = 0.3
            end
            if curScale > 3 then
                 curScale = 3
            end
            this._viewParent:setScale(curScale)

        end
    end
    local eventDispatcher = node:getEventDispatcher()
    --eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node);
    eventDispatcher:addEventListenerWithFixedPriority(listener, 99);
end
function viewManager.setAnchorOnly(node, pAnchor)
    local scale = node:getScale()
    local size = node:getContentSize()
    local width = size.width
    local height = size.height
    local pAnchorOld = node:getAnchorPoint()
    local diffx = (pAnchor.x - pAnchorOld.x) * width * scale
    local diffy = (pAnchor.y - pAnchorOld.y) * height * scale
    node:setPositionX(node:getPositionX() + diffx)
    node:setPositionY(node:getPositionY() + diffy)
    node:setAnchorPoint(pAnchor)
end
-- 移除线的时候 移除对应维护的数据
function viewManager:removeDataFromDeleteLine(lineData)

    local data = lineData:getData()
    local uuidStart = data.nodeDataStart:getuuid()
    local uuidEnd = data.nodeDataEnd:getuuid()
    local keyStart = data.keyStart
    local keyEnd = data.keyEnd
    local dataStart = DataManager:getDataForId(uuidStart)
    local dataEnd = DataManager:getDataForId(uuidEnd)
    if dataStart then
        dataStart:deleteDataFromLineList(keyStart, uuidEnd, keyEnd)
    end
    if dataEnd then
        dataEnd:deleteDataFromLineList(keyEnd, uuidStart, keyStart)
    end
end
function viewManager:registerEvent()
    local this = self
    -- 删除节点
    Event:addEventListener(enum.evt_keyboard.imgui_delete_node, function(event)
        local list = this.data.viewList
        local listNeedDelete = {}

        local isDelete = false
        -- 删除页面node
        for i, v in pairs(list) do
            if v:isSelect() then
                -- 移除页面
                v:destroy()
                list[i] = null
                -- 移除数据
                DataManager:removeData(i)

                table.insert(listNeedDelete, v)

                isDelete = true
            end
        end
        -- 删除连线
        local list = this.data.lineList
        for i, v in pairs(list) do
            if v:isSelect() then
                -- 移除线的时候 移除对应维护的数据
                this:removeDataFromDeleteLine(v)
                -- 删除连线
                v:destroy()
                list[i] = null

                isDelete = true
            elseif v:isCantainSelf(listNeedDelete) then
                -- 移除线的时候 移除对应维护的数据
                this:removeDataFromDeleteLine(v)
                -- 删除包含节点的连线
                v:destroy()
                list[i] = null

                isDelete = true
            end
        end

        if isDelete then
            this:addHistoryToList()
        end
    end)
    -- 移动节点
    Event:addEventListener(enum.evt_keyboard.imgui_move_node, function(event)
        local list = this.data.viewList
        local offX = event.offX
        local offY = event.offY
        local listNeedMove = {}

        if offX or offY then
            for i, v in pairs(list) do
                if v:isSelect() then
                    if offX then
                        v:addPositionX(offX)
                    end
                    if offY then
                        v:addPositionY(offY)
                    end
                    table.insert(listNeedMove, v)
                end
            end
        end
        if #listNeedMove > 0 then
            Event:dispatchEvent({
                name = enum.evt_keyboard.imgui_move_node_to_line,
                list = listNeedMove,
            })
        end

    end)

    Event:addEventListener(enum.evt_keyboard.sys_exit, function(event)
        -- 退出程序
        this:exitGame()
    end)
    Event:addEventListener(enum.evt_keyboard.sys_autosave, function(event)
        -- 自动保存
        local menu_mainbar = require("imguix/menu/menu_mainbar")
        menu_mainbar:AutoSaveFile()
    end)
    Event:addEventListener(enum.evt_keyboard.sys_backhistory, function(event)
        -- 自动保存
        this:backHistory()
    end)
end
-- 退出程序
function viewManager:exitGame()
    os.exit(0)
end
function viewManager:unRegisterEvent()
    Event:removeEventListenersByEvent(enum.evt_keyboard.imgui_delete_node)
    Event:removeEventListenersByEvent(enum.evt_keyboard.imgui_move_node)
    Event:removeEventListenersByEvent(enum.evt_keyboard.sys_exit)
    Event:removeEventListenersByEvent(enum.evt_keyboard.sys_autosave)
    Event:removeEventListenersByEvent(enum.evt_keyboard.sys_backhistory)
end
function viewManager:hide_imgui_menu_all()
    self:hide_imgui_menu_node()
    self:hide_imgui_menu_input()
end
-- 隐藏菜单
function viewManager:hide_imgui_menu_node()
    Event:dispatchEvent({
        name = enum.evt_keyboard.imgui_menu_node,
        isHide = true,
    })
end
-- 隐藏 弹出菜单
function viewManager:hide_imgui_menu_input()
    Event:dispatchEvent({
        name = enum.evt_keyboard.imgui_menu_input,
        isHide = true,
    })
end
-- 取消全部选中
function viewManager:unSelectAll()
    local list = self.data.viewList
    for i, v in pairs(list) do
        v:UnSelect()
    end
end


function viewManager:addToList(node)
    self.data.viewList[node.data:getuuid()] = node
end

function viewManager:initNodePos(node, posTab)
    if node then
        local menu_node = require("imguix/menu/menu_node")
        if posTab then
            node:setPositionX(posTab.x)
            node:setPositionY(posTab.y)
        else
            local posMenu = menu_node:getMenuPos()
            --dump(posMenu)
            local posLocal = self._viewParent:convertToNodeSpace(cc.p(posMenu.x, winHeight - posMenu.y))
            node:setPositionX(posLocal.x)
            node:setPositionY(posLocal.y)
        end
    end
end

function viewManager:createNode(dataNode, posTab, isNotResetHistory)

    -- 隐藏菜单
    self:hide_imgui_menu_all()

    if not self or not self._viewParent then
        print("开始 创建node 失败")
        return
    end
    print("创建node， type = ", dataNode:getName())
    try {
        function()
            local Node = null
            if false then
                Node = require ("res/render/view/node_sequence")
            else
                Node = require ("res/render/view/node_default")
            end
            if Node then
                local node = Node.new(dataNode)
                local viewNode = node.view
                self._viewParent:addChild(viewNode)
                self:initNodePos(viewNode, posTab)
                self:addToList(node)
            else
                print("创建 view 失败, type = ", dataNode:getName())
            end
            if not isNotResetHistory then
                self:addHistoryToList()
            end

        end, catch {
            function (err)
                print("创建node 失败")
                print(err)
            end
        }
    }

end
-- 开始拖动连线
function viewManager:startDropingLine(dropData)
    self.isDropingLine = true                       -- 是否正在拖动划线
    self.dataRropingLine = dropData                 -- 拖动中的对象

end
-- 刷新拖动连线
function viewManager:upStartDropingline(posEnd)
    if not self.nodeDropingLine then
        local posStart = self.dataRropingLine.posStart

        local data = {
            dirIn = self.dataRropingLine.dirIn,
            nodeDataStart = self.dataRropingLine.nodeStart,
            keyStart = self.dataRropingLine.keyPoint,
            pIn = self.dataRropingLine.posStart,
            pOut = self.dataRropingLine.posEnd,
        }

        self.nodeDropingLine = self:createLineBezier(posStart, posEnd, data)
    else
        self.nodeDropingLine:upDrawForPos(posEnd)
    end
end
-- 取消拖动连线
function viewManager:cancelDropingLine()
    self.isDropingLine = false
    self.dataRropingLine = null
    if self.nodeDropingLine then
        self.nodeDropingLine:destroy()
        self.nodeDropingLine = null
    end
end
function viewManager:isCanDropEnd(dropData)

    local endNodeData = dropData.endNodeData
    local keyPointEnd = dropData.keyPoint
    local startNodeData = self.dataRropingLine

    return endNodeData:isCanDropIn(startNodeData, keyPointEnd)
end
-- 结束拖动连线
function viewManager:endDropingLine(endData)
    if not endData then
        self:cancelDropingLine()
        return
    end
    local endNodeData = endData.endNodeData
    local keyPointEnd = endData.keyPoint
    local nodeStart = self.dataRropingLine.nodeStart
    local keyPointStart = self.dataRropingLine.keyPoint

    local posStart, dirIn = nodeStart:getDropPosForKey(keyPointStart)
    local posEnd, dirOut = endNodeData:getDropPosForKey(keyPointEnd)
    if posStart and posEnd then
        local data = {
            nodeDataStart = nodeStart,
            nodeDataEnd = endNodeData,
            keyStart = keyPointStart,
            keyEnd = keyPointEnd,
            dirOut = dirOut,
            dirIn = dirIn,
        }
        -- 创建连线
        local lineNode = self:createLineBezier(posStart, posEnd, data)
        self.data.lineList[lineNode:getuuid()] = lineNode
        -- 维护连线数据
        nodeStart:getData():addDataToLineList(keyPointStart, endNodeData:getuuid(), keyPointEnd)
        endNodeData:getData():addDataToLineList(keyPointEnd, nodeStart:getuuid(), keyPointStart)

        self:addHistoryToList()
    end
    -- 清除临时的连线
    self:cancelDropingLine()
end
-- 创建连线
function viewManager:createLineBezier(pIn, pOut, data)
    local NodeLine = require("render/common/nodeline")
    if not data then
        data = {}
    end
    local node = NodeLine.new({
        pIn = pIn,
        pOut = pOut,
        nodeDataStart = data.nodeDataStart,
        nodeDataEnd = data.nodeDataEnd,
        keyStart = data.keyStart,
        keyEnd = data.keyEnd,
        dirOut = data.dirOut,
        dirIn = data.dirIn,
    })
    self._lineParent:addChild(node.view)
    node:upDrawSelf()

    return node
end
-- 跳转到 view 中心
function viewManager:toCenterForId(id)
    local viewData = self:getNodeViewForId(id)
    if viewData then
        local posX = viewData:getPositionX()
        local posY = viewData:getPositionY()
        local parent = viewData:getParent()

        if parent then
            local posWorld = parent:convertToWorldSpace(cc.p(posX, posY))
            local width = cc.Director:getInstance():getWinSize().width
            local height = cc.Director:getInstance():getWinSize().height

            local offX =  width / 2 - posWorld.x
            local offY =  height / 2 - posWorld.y
            local posOffLocal = self._viewParent:getParent():convertToNodeSpace(cc.p(offX, offY))
            self._viewParent:setPositionX(self._viewParent:getPositionX() + posOffLocal.x)
            self._viewParent:setPositionY(self._viewParent:getPositionY() + posOffLocal.y)
        end

        --local mouseType = event:getMouseButton()
        --if mouseType == 1 and this._viewParent then
        --    local pos = event:getLocation()
        --    local pStart = this._mouseStart
        --    this._viewParent:setPositionX(this._parPosStartX + pos.x - pStart.x)
        --    this._viewParent:setPositionY(this._parPosStartY - pos.y + pStart.y)
        --end
    end
end

-- 左下角提示
function viewManager:showTip(message)
    local node = self._tipParent

    if not self._tipLab then
        local lab = cc.Label.createWithTTF(message, "font/FZLanTYJW.TTF", 25)
        node:addChild(lab)
        lab:setAnchorPoint(cc.p(0,0))
        lab:setPositionX(20)
        lab:setPositionY(10)
        lab:setColor(cc.c3b(255,255,255))
        self._tipLab = lab
    else
        self._tipLab:setString(message)
    end

    self._tipLab:setVisible(true)
    node:unschedule("showTip")
    node:scheduleOnce(function()
        self._tipLab:setVisible(false)
    end, 2, "showTip")
end

-- 移除所有 debug调试显示状态
function viewManager:resetAllDebugState()
    local viewList = self.data.viewList
    if viewList then
        for i, v in pairs(viewList) do
            v:setDebugState(enum.debug_state.none)
        end
    end
end

-- 添加当前状态为历史记录
function viewManager:addHistoryToList()

    local dataToSave = DataManager:get_alldata()
    local viewToSave = self:get_alldata()
    --local treeToSave = DataManager:get_export_tree()
    local jsonData =  {
        data = dataToSave,
        view = viewToSave,
        --tree = treeToSave,
    }

    table.insert(self.historylist, jsonData)
    if #self.historylist > 20 then
        table.remove(self.historylist, 1)
    end
end

-- 恢复上一步的历史记录
function viewManager:backHistory()
    local list = self.historylist
    print(#self.historylist)
    if #list <= 1 then
        self:showTip("已恢复到最后一步历史记录")
        return
    end

    table.remove(list)
    local jsonData = list[#list]
    -- 打开之前 先还原
    DataManager:reset()
    self:reset(true)
    -- 重新初始化
    DataManager:init(jsonData, true)

    self:showTip("恢复上一步成功")
end

return viewManager