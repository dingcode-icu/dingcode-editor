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

function NodeLine:getData()
    return self.data
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
                local posStart, dirIn = nodeDataStart:getDropPosForKey(keyStart)
                local posEnd, dirOut = nodeDataEnd:getDropPosForKey(keyEnd)
                if posStart and posEnd then
                    if dirIn then
                        self.data.dirIn = dirIn
                    end
                    if dirOut then
                        self.data.dirOut = dirOut
                    end
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
    local dirIn = self.data.dirIn
    local dirOut = self.data.dirOut

    pIn = self.view:getParent():convertToNodeSpace(pIn)
    pOut = self.view:getParent():convertToNodeSpace(pOut)

    local offX = math.abs(pOut.x - pIn.x) * 0.7
    local offY = math.abs(pOut.y - pIn.y) * 0.7
    if offX < 150 then
        offX = 150
    end
    if offY < 150 then
        offY = 150
    end
    local offX1 = 0
    local offY1 = 0
    local offX2 = 0
    local offY2 = 0
    if dirIn == enum.node_direct.top then
        offY1 = offY
    elseif dirIn == enum.node_direct.bottom then
        offY1 = -offY
    elseif dirIn == enum.node_direct.left then
        offX1 = -offX
    elseif dirIn == enum.node_direct.right then
        offX1 = offX
    end
    if dirOut == enum.node_direct.top then
        offY2 = offY
    elseif dirOut == enum.node_direct.bottom then
        offY2 = -offY
    elseif dirOut == enum.node_direct.left then
        offX2 = -offX
    elseif dirOut == enum.node_direct.right then
        offX2 = offX
    end

    local t = 0.5
    local pointX = math.pow(1 - t, 3) * pIn.x + 3 * math.pow(1 - t, 2) * t * (pIn.x + offX1 / 2) + 3 * (1 - t) * t * t * (pOut.x + offX2 / 2) + t * t * t * pOut.x;
    local pointY = math.pow(1 - t, 3) * pIn.y + 3 * math.pow(1 - t, 2) * t * (pIn.y + offY1 / 2) + 3 * (1 - t) * t * t * (pOut.y + offY2 / 2) + t * t * t * pOut.y;
    self.nodeLinePoint:setPositionX(pointX)
    self.nodeLinePoint:setPositionY(pointY)

    self.view:drawCubicBezier(pIn, cc.p(pIn.x + offX1 / 2,pIn.y + offY1 / 2), cc.p(pOut.x + offX2 / 2,pOut.y + offY2 / 2), pOut, 30, cc.c4f(1, 1, 1, 1))
end
-- 获取 需要保存的连线数据
function NodeLine:getDataToSave()
    return {
        uuidStart = self.data.nodeDataStart:getuuid(),
        uuidEnd = self.data.nodeDataEnd:getuuid(),
        keyStart = self.data.keyStart,
        keyEnd = self.data.keyEnd,
    }
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