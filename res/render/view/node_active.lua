local NodeActive = class("NodeActive", cc.Node)
--local NodeActive = class("NodeActive", function()
--    return cc.Node:create()
--end)
function NodeActive:ctor(viewname)
    --self.super.ctor(self)
    return cc.Node:create()
end

return NodeActive