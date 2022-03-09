local NodeLine = class("NodeLine")
local Event = require("res/lib/event")

function NodeLine:ctor(data)
    self.data = data
    self.uuid = ding.guid()

    local drawNode = cc.DrawNode.create(4)
    self.view = drawNode

    self:initView()
end

function NodeLine:initView()
    self:initEvent()
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