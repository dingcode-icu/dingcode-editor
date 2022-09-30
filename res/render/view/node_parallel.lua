local DataBase = require("render/view/basenode")
local NodeParallel = class("NodeParallel", DataBase)

function NodeParallel:ctor(data)
    self.super.ctor(self, data)

    self:initView()

    self:ShowName()
end

function NodeParallel:initView()
    local node = cc.Sprite.create("assets/texture/while.png")
    self.view:addChild(node)
    local size = node:getContentSize()
    node:setPositionX(size.width / 2)
    node:setPositionY(size.height / 2)

    self:setContentSize(size)

    -- 注册 点击事件
    self:registerTouch()

    if self.touchListener then
        local this = self
    end
end

return NodeParallel
