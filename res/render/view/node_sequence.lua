local DataBase = require("render/view/basenode")
local NodeSequence = class("NodeSequence", DataBase)

function NodeSequence:ctor(data)
    self.super:ctor(data)

    self:initView()

    self:ShowName()
end

function NodeSequence:initView()
    local node = cc.Sprite.create("texture/while.png")
    self.view:addChild(node)
    local size = node:getContentSize()
    node:setPositionX(size.width / 2)
    node:setPositionY(size.height / 2)

    self:setContentSize(size)

    -- 注册 点击事件
    self:registerTouch()

    if self.touchListener then
        local this = self
        self.touchListener.onTouchEnded = function(touch, event)
            print("click node", this.data:getuuid())
        end
    end
end

return NodeSequence