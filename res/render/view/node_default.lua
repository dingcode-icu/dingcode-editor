local DataBase = require("render/view/basenode")
local NodeDefault = class("NodeDefault", DataBase)

function NodeDefault:ctor(data)
    self.super.ctor(self, data)
end
--
--function NodeDefault:initView()
--    local node = cc.Sprite.create("texture/while.png")
--    self.view:addChild(node)
--    local size = node:getContentSize()
--    node:setPositionX(size.width / 2)
--    node:setPositionY(size.height / 2)
--
--    self:setContentSize(size)
--
--    self:initTreePoint()
--
--    -- 注册 点击事件
--    self:registerTouch()
--
--    if self.touchListener then
--        local this = self
--    end
--end

return NodeDefault