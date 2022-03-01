local BaseNode = class("BaseNode")

function BaseNode:ctor()
    local node = cc.Node.create()
    self.view = node
end

function BaseNode:ShowName()
    if self.view then
        local lab = cc.Label.createWithTTF("helloworld", "font/FZLanTYJW.TTF", 15)
        self.view:addChild(lab)
        lab:setString(self.__cname)
        local size = self.view:getContentSize()
        lab:setPositionX(size.width / 2)
        lab:setPositionY(size.height / 2)
        lab:setColor(cc.c3b(0,255,0))
    end
end

function BaseNode:setContentSize(size)
    if self.view then
        self.view:setContentSize(size)
    end
end

return BaseNode