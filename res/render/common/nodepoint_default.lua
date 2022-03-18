local BaseNodePoint = require("render/common/base_nodepoint")
local NodeInput = class("NodeInput", BaseNodePoint)
local ViewManager = require("render/viewmanager")
local enum = enum

function NodeInput:ctor(data)

    self.super.ctor(self, data)

    self:init()

end

function NodeInput:init()
    local parent = self.data.parent
    local key = self.data.key

    local nodePoint = cc.Sprite.create("texture/point.png")
    local size = nodePoint:getContentSize()
    self:setContentSize(size)

    local nodePointSelect = cc.Sprite.create("texture/linePoint.png")
    nodePointSelect:setPositionX(size.width / 2)
    nodePointSelect:setPositionY(size.height / 2)
    self.view:addChild(nodePointSelect)
    self._nodePointSelect = nodePointSelect
    self:select(false)

    self.view:addChild(nodePoint)
    nodePoint:setPositionX(size.width / 2)
    nodePoint:setPositionY(size.height / 2)

end

function NodeInput:select(isSelect)
    if self._nodePointSelect then
        self._nodePointSelect:setVisible(isSelect)
    end
end

return NodeInput