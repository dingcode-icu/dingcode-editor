local DataBase = require("render/view/basenode")
local NodeDefault = class("NodeDefault", DataBase)

function NodeDefault:ctor(data)
    self.super.ctor(self, data)

    self:initView()

    self:ShowName()
end

function NodeDefault:initView()
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

            local isClick = this.super.onTouchEnded(touch, event)
            if isClick then
                print("click node", this.data:getuuid())
                this:ClickSelect()
            end

            return isClick
        end
    end
end

return NodeDefault