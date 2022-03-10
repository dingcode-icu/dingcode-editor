local NodeLine = class("NodeLine")
local Event = require("res/lib/event")

function NodeLine:ctor(data)
    self.data = data
    self.uuid = ding.guid()
    self.nodeLinePointSelect = null
    self.nodeLinePoint = null

    local drawNode = cc.DrawNode.create(4)
    self.view = drawNode

    self:initView()
end

function NodeLine:initView()
    self:initEvent()

    local nodeLinePoint = cc.Sprite.create("texture/linePoint.png")
    self.view:addChild(nodeLinePoint)
    self.nodeLinePoint = nodeLinePoint

    self:registerTouch()
end


function NodeLine:registerTouch()
    local this = self
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true);
    listener.onTouchBegan = function(touch, event)

        local isTouch = this.isTouchSelf(touch, event)
        if isTouch then
            return true
        end
        return false
    end
    listener.onTouchMoved = function(touch, event)
        return false
    end
    listener.onTouchEnded = function(touch, event)

        local isClick = this.isTouchSelf(touch, event)
        if isClick then
            this:ClickSelect()
        end

        return isClick
    end
    listener.onTouchCancelled = function(touch, event)

        return false
    end
    local eventDispatcher = self.nodeLinePoint:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.nodeLinePoint);

end

-- 是否点击自己
function NodeLine.isTouchSelf(touch, event)
    local target = event:getCurrentTarget()
    local size = target:getContentSize()
    if NodeLine.isTouchInsideNode(touch, target, size) then
        return true
    end
    return false
end
-- 是否在自己点击范围内
function NodeLine.isTouchInsideNode(pTouch,node,nodeSize)

    local pos = pTouch:getLocation()
    local point = node:convertToNodeSpace(pos)
    local x,y = point.x,point.y
    if x >= 0 and x <= nodeSize.width and y >= 0 and y <= nodeSize.height then
        return true
    end
end
-- 是否选中
function NodeLine:isSelect()
    if self.nodeLinePointSelect and self.nodeLinePointSelect:isVisible() then
        return true
    end
    return false
end
-- 初始化 选中节点
function NodeLine:initSelectNode()
    if not self.nodeLinePointSelect then
        local nodeLinePointSelect = cc.Sprite.create("texture/linePointSelect.png")
        self.nodeLinePoint:addChild(nodeLinePointSelect)
        --local size = node:getContentSize()
        local sizeParent = self.nodeLinePoint:getContentSize()
        nodeLinePointSelect:setPositionX(sizeParent.width / 2)
        nodeLinePointSelect:setPositionY(sizeParent.height / 2)
        self.nodeLinePointSelect = nodeLinePointSelect
    end
end
-- 选中
function NodeLine:Select()
    self:initSelectNode()
    self.nodeLinePointSelect:setVisible(true)
end
-- 取消选中
function NodeLine:UnSelect()
    if self.nodeLinePointSelect then
        self.nodeLinePointSelect:setVisible(false)
    end
end
-- 反选
function NodeLine:ClickSelect()
    if self:isSelect() then
        self:UnSelect()
    else
        self:Select()
    end
end

function NodeLine:initEvent()
    local this = self

    Event:addEventListener(enum.evt_keyboard.imgui_move_node_to_line, function(event)

        local nodeDataStart = this.data.nodeDataStart
        local nodeDataEnd = this.data.nodeDataEnd
        local keyStart = this.data.keyStart
        local keyEnd = this.data.keyEnd
        local list = event.list
        local isIn = false

        if nodeDataEnd and nodeDataStart then
            for i, v in pairs(list) do
                if v:getuuid() == nodeDataStart:getuuid() or v:getuuid() == nodeDataEnd:getuuid() then
                    isIn = true
                    break
                end
            end

            if keyStart and keyEnd then
                local posStart = nodeDataStart:getDropPosForKey(keyStart)
                local posEnd = nodeDataEnd:getDropPosForKey(keyEnd)
                if posStart and posEnd then
                    self.data.pIn = posStart
                    self.data.pOut = posEnd
                    self:upDrawSelf()
                end
            end
        end

    end, this)
end

function NodeLine:getuuid()
    return self.uuid
end
-- 是否包含自己的起始和结束节点
function NodeLine:isCantainSelf(list)
    local nodeDataStart = self.data.nodeDataStart
    local nodeDataEnd = self.data.nodeDataEnd

    for i, v in pairs(list) do
        if (nodeDataStart and v:getuuid() == nodeDataStart:getuuid()) or (nodeDataEnd and v:getuuid() == nodeDataEnd:getuuid()) then
            return true
        end
    end
    return false
end
-- 根据结束点坐标刷新
function NodeLine:upDrawForPos(pOut)
    if self.view then

        self.data.pOut = pOut

        self:upDrawSelf()
    end
end
-- 直接刷新
function NodeLine:upDrawSelf()
    self.view:clear()
    local pIn = self.data.pIn
    local pOut = self.data.pOut
    pIn = self.view:getParent():convertToNodeSpace(pIn)
    pOut = self.view:getParent():convertToNodeSpace(pOut)

    local offX = pOut.x - pIn.x
    local offY = pOut.y - pIn.y
    self.nodeLinePoint:setPositionX(pIn.x + offX / 2)
    self.nodeLinePoint:setPositionY(pIn.y + offY / 2)


    self.view:drawCubicBezier(pIn, cc.p(pIn.x + offX / 2,pIn.y), cc.p(pOut.x - offX / 2,pOut.y), pOut, 30, cc.c4f(1, 1, 1, 1))
end

function NodeLine:removeFromParentAndCleanup(cleanup)
    if self.view then
        self.view:removeFromParentAndCleanup(cleanup)
    end
end

function NodeLine:destroy()
    self:removeFromParentAndCleanup(true)
    Event:removeEventListenersByTag(self)
end

return NodeLine