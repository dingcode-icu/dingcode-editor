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
    local keyconfig = self.data.keyconfig

    self:setContentSize(cc.size(30, 20))

    local size = self.view:getContentSize()

    local nodePoint = cc.Sprite.create("texture/point.png")
    self.view:addChild(nodePoint)
    nodePoint:setPositionX(size.width / 2)
    nodePoint:setPositionY(size.height / 2)

    if keyconfig and keyconfig.desc then
        local lab = cc.Label.createWithTTF(keyconfig.desc, "font/FZLanTYJW.TTF", 15)
        self.view:addChild(lab)
        lab:setAnchorPoint(cc.p(0, 0.5))
        lab:setPositionX(size.width)
        lab:setPositionY(size.height / 2)
        lab:setColor(cc.c3b(0,255,0))
        self._labValue = lab
    end

    self:initWithData()
end

function NodeInput:initWithData()
    local value = self:getValue()
    if value then
       self:setValue(value, true)
    end
end

function NodeInput:setValue(value, isInit)
    if self._labValue then
        value = GetPreciseDecimal(value, 3)
        -- 设置数据
        if not isInit then
            -- 初始化的时候 恢复数据 不需要设置数据
            local dataNode = self.data.parent:getData()
            local key = self.data.key
            dataNode:setListInputForId(key, {value})
        end
        -- 设置页面
        local labValue = "" .. value
        if string.len(value) >= 6 then
            labValue = string.sub(value, 1, 4) .. "..."
        end
        self._labValue:setString("" .. labValue)
    end
end

function NodeInput:getValue()
    local dataNode = self.data.parent:getData()
    local key = self.data.key
    local listinput = dataNode:getListInputForId(key)
    if listinput and #listinput > 0 then
        return listinput[1]
    end
    return nil
end

return NodeInput