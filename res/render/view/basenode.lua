local BaseNode = class("BaseNode")

function BaseNode:ctor()
    local node = cc.Node.create()
    node:setAnchorPoint(cc.p(0.5, 0.5))
    self.view = node
end

function BaseNode:ShowName()
    if self.view then
        local lab = cc.Label.createWithTTF(self.__cname, "font/FZLanTYJW.TTF", 15)
        self.view:addChild(lab)
        --lab:setString(self.__cname)
        local size = self.view:getContentSize()
        lab:setPositionX(size.width / 2)
        lab:setPositionY(size.height / 2)
        lab:setColor(cc.c3b(0,255,0))
    end
end

function BaseNode:registerTouch()

    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true);
    listener.onTouchBegan = self.onTouchBegan
    listener.onTouchMoved = self.onTouchMoved
    listener.onTouchEnded = self.onTouchEnded
    listener.onTouchCancelled = self.onTouchCancelled
    local eventDispatcher = self.view:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.view);

end

function BaseNode:setContentSize(size)
    if self.view then
        self.view:setContentSize(size)
    end
end

function BaseNode.onTouchBegan(touch, event)
    local target = event:getCurrentTarget()
    local boundingBox = target:getBoundingBox()
    local p = touch:getLocation()
    --local pLocal = target:convertToNodeSpace(p)
    if boundingBox:containsPoint(p) then
        return true
    end
    return false
end
function BaseNode.onTouchMoved(touch, event)
    return false
end
function BaseNode.onTouchEnded(touch, event)
    return false
end
function BaseNode.onTouchCancelled(touch, event)
    return false
end



return BaseNode