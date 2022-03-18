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

    self:setContentSize(cc.size(30, 20))

    local size = self.view:getContentSize()

    local nodePoint = cc.Sprite.create("texture/point.png")
    self.view:addChild(nodePoint)
    nodePoint:setPositionX(size.width / 2)
    nodePoint:setPositionY(size.height / 2)

    local lab = cc.Label.createWithTTF("输入", "font/FZLanTYJW.TTF", 15)
    self.view:addChild(lab)
    lab:setPositionX(size.width / 2)
    lab:setPositionY(size.height / 2)
    lab:setColor(cc.c3b(0,255,0))
    self._labValue = lab

end

function NodeInput:setValue(value)
    if self._labValue then
        value = GetPreciseDecimal(value, 3)
        -- 设置数据
        local dataNode = self.data.parent:getData()
        local key = self.data.key
        dataNode:setListInputForId(key, {value})
        -- 设置页面
        self._labValue:setString("" .. value)
    end
end

return NodeInput