-- 节点上 可点击的点的基类
local BaseNodePoint = {}

function BaseNodePoint:ctor(data)
    self.data = data
    local root = cc.Node.create()
    self.view = root
end

function BaseNodePoint:select(isSelect)
    print("子类需要实现 BaseNodePoint:select", isSelect)
end
function BaseNodePoint:getConfigKey()
    return self.data.keyconfig.key or ""
end

function BaseNodePoint:setContentSize(size)
    if self.view then
        self.view:setContentSize(size)
    end
end
function BaseNodePoint:getContentSize()
    if self.view then
        return self.view:getContentSize()
    end
end

function BaseNodePoint:convertToNodeSpace(pos)
    if self.view then
        return self.view:convertToNodeSpace(pos)
    end
end
function BaseNodePoint:getParent()
    return self.view:getParent()
end
function BaseNodePoint:getPositionX()
    -- TODO 返回拖动节点的位置
    return self.view:getPositionX()
end
function BaseNodePoint:getPositionY()
    -- TODO 返回拖动节点的位置
    return self.view:getPositionY()
end

return BaseNodePoint