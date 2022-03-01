local DataBase = require("render/view/basenode")
local NodeSequence = class("NodeSequence", DataBase)

function NodeSequence:ctor()
    self.super:ctor()

    self:initView()

    self:ShowName()
end

function NodeSequence:initView()
    local node = cc.Sprite.create("texture/while.png")
    self.view:addChild(node)
    local size = node:getContentSize()
    node:setPositionX(size.width / 2)
    node:setPositionY(size.height / 2)

    self:setContentSize(size)

    -- 注册 点击事件
    self:registerTouch()
    --local listener = cc.EventListenerTouchOneByOne:create();
    --listener:setSwallowTouches(true);
    --listener.onTouchBegan = function()
    --    return false
    --end
    --listener.onTouchMoved = function()
    --    --print("2")
    --    return true
    --end
    --listener.onTouchEnded = function(event1, event2)
    --    --local mouseType = event:getButton()
    --    print("img ========")
    --    return true
    --end
    --listener.onTouchCancelled = function()
    --    --print("4")
    --    return true
    --end
    --local eventDispatcher = self.view:getEventDispatcher()
    --eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.view);

end

return NodeSequence