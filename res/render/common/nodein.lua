local NodeIn = class("NodeIn")
local ViewManager = require("render/viewmanager")
local enum = enum

function NodeIn:ctor(data)
    self.data = data

    local root = cc.Node.create()
    self.view = root

    self:init()

end

function NodeIn:init()
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

end

function NodeIn:setContentSize(size)
    if self.view then
        self.view:setContentSize(size)
    end
end
function NodeIn:getContentSize()
    if self.view then
        return self.view:getContentSize()
    end
end
function NodeIn:convertToNodeSpace(pos)
    if self.view then
        return self.view:convertToNodeSpace(pos)
    end
end
function NodeIn:getParent()
    return self.view:getParent()
end
function NodeIn:getPositionX()
    -- TODO 返回拖动节点的位置
    return self.view:getPositionX()
end
function NodeIn:getPositionY()
    -- TODO 返回拖动节点的位置
    return self.view:getPositionY()
end

return NodeIn