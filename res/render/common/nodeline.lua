local NodeLine = class("NodeLine")
local Event = require("res/lib/event")

function NodeLine:ctor(data)
    self.data = data
    local pIn = data.pIn
    local pOut = data.pOut

    local drawNode = cc.DrawNode.create(4)
    local offX = pOut.x - pIn.x
    drawNode:drawCubicBezier(pIn, cc.p(pIn.x + offX / 2,pIn.y), cc.p(pOut.x - offX / 2,pOut.y), pOut, 30, cc.c4f(1, 1, 1, 1))
    self.view = drawNode
end

function NodeLine:upDrawForPos(pOut)
    if self.view then
        self.view:clear()

        local pIn = self.data.pIn
        local offX = pOut.x - pIn.x
        self.view:drawCubicBezier(pIn, cc.p(pIn.x + offX / 2,pIn.y), cc.p(pOut.x - offX / 2,pOut.y), pOut, 30, cc.c4f(1, 1, 1, 1))
    end
end

function NodeLine:removeFromParentAndCleanup(cleanup)
    if self.view then
        self.view:removeFromParentAndCleanup(cleanup)
    end
end

return NodeLine