local BaseNode = class("BaseNode")
local Event = require("res/lib/event")
local ViewManager = require("res/render/viewmanager")
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
function BaseNode:setPositionX(x)
    if self.view then
        self.view:setPositionX(x)
    end
end
function BaseNode:setPositionY(x)
    if self.view then
        self.view:setPositionY(x)
    end
end
function BaseNode:addPositionX(x)
    if self.view and x then
        self:setPositionX(x + self.view:getPositionX())
    end
end
function BaseNode:addPositionY(x)
    if self.view and x then
        self:setPositionY(x + self.view:getPositionY())
    end
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

function BaseNode:initPoint()
    local size = self:getContentSize()
    local nodePoint = cc.Sprite.create("texture/point.png")
    self.view:addChild(nodePoint)
    nodePoint:setPositionX(8)
    nodePoint:setPositionY(size.height / 2)
    self._nodePoint = nodePoint
end

-- 点击相关
function BaseNode:registerTouch()
    local this = self
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true);
    listener.onTouchBegan = function(touch, event)
        if ViewManager and ViewManager.isDropingLine then
            return false
        end

        if self._nodePoint then
            local size = this._nodePoint:getContentSize()
            if this.isTouchInsideNode(touch, this._nodePoint, size) then
                local pos = touch:getLocation()
                local dropData = {
                    posStart = pos,
                    posEnd = pos,
                }
                ViewManager:startDropingLine(dropData)
                return false
            end
        end


        local isTouch = this.isTouchSelf(touch, event)
        if isTouch then
            this._touchStart = touch:getLocation()
            local target = event:getCurrentTarget()
            this._pStartX = target:getPositionX()
            this._pStartY = target:getPositionY()
            return true
        end
        return false
    end
    listener.onTouchMoved = function(touch, event)
        if ViewManager and ViewManager.isDropingLine then
            return false
        end

        if this._touchStart then
            if not this:isSelect() then
                -- 未选中 拖动自己
                local pos = touch:getLocation()
                local posStart = this._touchStart
                local target = event:getCurrentTarget()
                target:setPositionX(this._pStartX + pos.x - posStart.x)
                target:setPositionY(this._pStartY + pos.y - posStart.y)
                return false
            else
                -- 选中 拖动所有已选中的点
                local pos = touch:getLocation()
                local posStart = this._touchStart
                local target = event:getCurrentTarget()
                local offX = this._pStartX + pos.x - posStart.x - target:getPositionX()
                local offY = this._pStartY + pos.y - posStart.y - target:getPositionY()

                Event:dispatchEvent({
                    name = enum.eventconst.imgui_move_node,
                    offX = offX,
                    offY = offY,
                })
            end
        end

    end
    listener.onTouchEnded = function(touch, event)
        if ViewManager and ViewManager.isDropingLine then
            return false
        end

        this._touchStart = null
        return this.isTouchSelf(touch, event)
    end
    listener.onTouchCancelled = function(touch, event)
        if ViewManager and ViewManager.isDropingLine then
            return false
        end

        this._touchStart = null
        return false
    end
    local eventDispatcher = self.view:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.view);

    self.touchListener = listener
end
-- 是否点击自己
function BaseNode.isTouchSelf(touch, event)
    local target = event:getCurrentTarget()
    local size = target:getContentSize()
    if BaseNode.isTouchInsideNode(touch, target, size) then
        return true
    end
    return false
end
-- 是否在自己点击范围内
function BaseNode.isTouchInsideNode(pTouch,node,nodeSize)
    local point = node:convertTouchToNodeSpace(pTouch)
    local x,y = point.x,point.y
    if x >= 0 and x <= nodeSize.width and y >= 0 and y <= nodeSize.height then
        return true
    end
end
-- 判断是否点击
function BaseNode.isClickForTouch(touch)
    local pEnd = touch:getLocation()
    local pStart = touch:getStartLocation()
    if math.abs(pStart.x - pEnd.x) < 10 and math.abs(pStart.y - pEnd.y) < 10 then
        return true
    end
    return false
end



return BaseNode