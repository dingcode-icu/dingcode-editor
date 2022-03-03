local DataManager = require("res/data/datamanager")
local Event = require("res/lib/event")
local enum = enum
--local winWidth = cc.Director:getInstance():getWinSize().width
local winHeight = cc.Director:getInstance():getWinSize().height

local viewManager = {
    data = {
        viewList = {},                      -- 创建的数据
    },
    isInit = false,                         -- 是否已经初始化

    _viewParent = null,
}

function viewManager:init(config)
    if config then
        if config.dataList then

        end
    end

    self.isInit = true
end

function viewManager:initViewParent()
    local node = cc.Node.create()
    node:setContentSize(cc.size(9999,9999))
    self._viewParent = node

    local scene = cc.Director:getInstance():getRunningScene()
    scene:addChild(node)

    self:registerTouch()
    self:registerEvent()
end
function viewManager:registerTouch()
    local node = self._viewParent
    local this = self
    -- 注册 点击事件
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true);
    listener.onTouchBegan = function()
        --print("111")
        return true
    end
    listener.onTouchMoved = function()
        --print("2")
        return true
    end
    listener.onTouchEnded = function(event1, event2)
        --local mouseType = event:getButton()
        this:hide_imgui_menu_node()
        this:unSelectAll()
        print("viewmanager touch end")
        return true
    end
    listener.onTouchCancelled = function()
        --print("4")
        return true
    end
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node);

    -- 注册 右键点击
    local listener = cc.EventListenerMouse:create();
    listener.onMouseDown = function(event)
        local mouseType = event:getMouseButton()
        if mouseType == 0 then
            --print("左键点击")
            -- 关闭菜单会拦截菜单的点击
        elseif mouseType == 1 then
            -- print("右键点击")
            local pos = event:getLocation()
            print(pos.x, pos.y)
            Event:dispatchEvent({
                name = enum.eventconst.imgui_menu_node,
                posX = pos.x,
                posY = pos.y,
            })
        end
        return true
    end

    listener.onMouseScroll = function(event)
        local menu_node = require("res/imguix/menu/menu_node")
        --local menu_mainbar = require("res/imguix/menu/menu_mainbar")
        if menu_node:isShow() then
            return
        end
        -- 鼠标滚轮 缩放
        local scrollY = event:getScrollY()
        if this._viewParent then
            local curScale = this._viewParent:getScale() + scrollY * 0.1
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
function viewManager:registerEvent()
    local this = self
    Event:addEventListener(enum.eventconst.imgui_delete_node, function(event)
        local list = this.data.viewList
        for i, v in pairs(list) do
            if v:isSelect() then
                -- 移除页面
                v:removeFromParentAndCleanup(true)
                list[i] = null
                -- 移除数据
                DataManager:removeData(i)
            end
        end
    end)
end
function viewManager:unRegisterEvent()
    Event:removeEventListenersByEvent(enum.eventconst.imgui_delete_node)
end

-- 隐藏菜单
function viewManager:hide_imgui_menu_node()
    Event:dispatchEvent({
        name = enum.eventconst.imgui_menu_node,
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

function viewManager:initNodePos(node)
    if node then
        local menu_node = require("res/imguix/menu/menu_node")
        local posMenu = menu_node:getMenuPos()
        --dump(posMenu)
        node:setPositionX(posMenu.x)
        node:setPositionY(winHeight - posMenu.y)

    end
end

function viewManager:createNode(dataNode)

    -- 隐藏菜单
    self:hide_imgui_menu_node()

    if not self or not self._viewParent then
        print("创建node 失败")
        return
    end
    print("创建node， type = ", dataNode:gettype())
    try {
        function()
            local Node = null
            if enum.nodetype.sequence == dataNode:gettype() then
                Node = require ("res/render/view/node_sequence")
            elseif enum.nodetype.parallel == dataNode:gettype() then
                Node = require ("res/render/view/node_parallel")
            elseif enum.nodetype.selector == dataNode:gettype() then
                Node = require ("res/render/view/node_selector")
            else
                Node = require ("res/render/view/node_default")
            end
            if Node then
                local node = Node.new(dataNode)
                local viewNode = node.view
                self:initNodePos(viewNode)
                self._viewParent:addChild(viewNode)
                self:addToList(node)
            else
                print("创建 view 失败, type = ", dataNode:gettype())
            end
        end, catch {
            function (err)
                print("创建node 失败")
                print(err)
            end
        }
    }

end

return viewManager