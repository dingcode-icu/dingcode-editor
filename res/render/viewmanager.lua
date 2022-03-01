local DataManager = require("res/data/datamanager")
local Event = require("res/lib/event")
local enum = enum
--local winWidth = cc.Director:getInstance():getWinSize().width
local winHeight = cc.Director:getInstance():getWinSize().height

local viewManager = {
    view = {
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
        viewManager:hide_imgui_menu_node()
        print("touch end")
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
    local eventDispatcher = node:getEventDispatcher()
    --eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node);
    eventDispatcher:addEventListenerWithFixedPriority(listener, 99);

end

-- 隐藏菜单
function viewManager:hide_imgui_menu_node()
    Event:dispatchEvent({
        name = enum.eventconst.imgui_menu_node,
        isHide = true,
    })
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
            if enum.nodetype.sequence == dataNode:gettype() then
                local Node = require ("res/render/view/node_sequence")
                local node = Node.new()
                local viewNode = node.view
                self:initNodePos(viewNode)
                self._viewParent:addChild(viewNode)
            end
        end, catch {
            function (err)
                print("创建node 失败")
                print(err)
            end
        }
    }
    --if enum.nodetype.sequence == dataNode:gettype() then
    --    local NodeActive = require ("res/render/view/node_sequence")
    --    local node = NodeActive.new()
    --    self._viewParent:addChild(node)
    --end
end

return viewManager