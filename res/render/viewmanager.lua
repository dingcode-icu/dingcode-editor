local DataManager = require("res/data/datamanager")

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
    listener.onTouchEnded = function()
        print("end")
        return true
    end
    listener.onTouchCancelled = function()
        --print("4")
        return true
    end

    local eventDispatcher = node:getEventDispatcher()
    print(eventDispatcher)
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node);

end

function viewManager:createNode(dataNode)
    print("创建node， type = ", dataNode:gettype())
end

return viewManager