local BaseNode = class("BaseNode")
local enum = enum

function BaseNode:ctor(data)
    self.data = data
    self.touchListener = null           -- 点击监听
    self.selectNode = null              -- 选中的节点（null/active=false 表示未选中）

    local node = cc.Node.create()
    node:setAnchorPoint(cc.p(0.5, 0.5))
    self.view = node
end

function BaseNode:ShowName()
    if self.view then
        local lab = cc.Label.createWithTTF(self:getNameForType(), "font/FZLanTYJW.TTF", 15)
        self.view:addChild(lab)
        --lab:setString(self.__cname)
        local size = self.view:getContentSize()
        lab:setPositionX(size.width / 2)
        lab:setPositionY(size.height / 2)
        lab:setColor(cc.c3b(0,255,0))
    end
end
function BaseNode:getNameForType()
    if self.data then
        if self.data:gettype() then
            for i, v in pairs(enum.nodetype) do
                if v == self.data:gettype() then
                    return i
                end
            end
        end
    end
    return "default"
end

function BaseNode:setContentSize(size)
    if self.view then
        self.view:setContentSize(size)
    end
end
function BaseNode:getContentSize()
    if self.view then
        return self.view:getContentSize()
    end
    return null
end
function BaseNode:removeFromParentAndCleanup(cleanup)
    if self.view then
        self.view:removeFromParentAndCleanup(cleanup)
    end
end
-- 是否选中
function BaseNode:isSelect()
    if self.selectNode and self.selectNode:isVisible() then
        return true
    end
    return false
end
-- 初始化 选中节点
function BaseNode:initSelectNode()
    if not self.selectNode then
        local node = cc.Sprite.create("texture/select.png")
        self.view:addChild(node)
        --local size = node:getContentSize()
        local sizeParent = self:getContentSize()
        node:setPositionX(sizeParent.width / 2)
        node:setPositionY(sizeParent.height / 2)
        self.selectNode = node
    end
end
-- 选中
function BaseNode:Select()
    self:initSelectNode()
    self.selectNode:setVisible(true)
end
-- 取消选中
function BaseNode:UnSelect()
    if self.selectNode then
        self.selectNode:setVisible(false)
    end
end
-- 反选
function BaseNode:ClickSelect()
    if self:isSelect() then
        self:UnSelect()
    else
        self:Select()
    end
end


-- 点击相关
function BaseNode:registerTouch()

    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true);
    listener.onTouchBegan = self.onTouchBegan
    listener.onTouchMoved = self.onTouchMoved
    listener.onTouchEnded = self.onTouchEnded
    listener.onTouchCancelled = self.onTouchCancelled
    local eventDispatcher = self.view:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.view);

    self.touchListener = listener
end
function BaseNode.onTouchBegan(touch, event)
    local target = event:getCurrentTarget()
    local size = target:getContentSize()
    --local p = touch:getLocation()
    if BaseNode.isTouchInsideNode(touch, target, size) then
        return true
    end
    return false
end
function BaseNode.onTouchMoved(touch, event)
    return false
end
function BaseNode.onTouchEnded(touch, event)
    local target = event:getCurrentTarget()
    local size = target:getContentSize()
    --local p = touch:getLocation()
    if BaseNode.isTouchInsideNode(touch, target, size) then
        return true
    end
    return false
end
function BaseNode.onTouchCancelled(touch, event)
    return false
end
function BaseNode.isTouchInsideNode(pTouch,node,nodeSize)
    local point = node:convertTouchToNodeSpace(pTouch)
    local x,y = point.x,point.y
    if x >= 0 and x <= nodeSize.width and y >= 0 and y <= nodeSize.height then
        return true
    end
end



return BaseNode