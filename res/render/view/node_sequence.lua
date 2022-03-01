local DataBase = require("render/view/basenode")
local NodeSequence = class("NodeSequence", DataBase)

function NodeSequence:ctor()
    self.super:ctor()

    local node = cc.Sprite.create("texture/while.png")
    self.view:addChild(node)
    --self:setContentSize(node:getContentSize())

    self:ShowName()
end

return NodeSequence