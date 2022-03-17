local DataBase = require("render/view/basenode")
local NodeDefault = class("NodeDefault", DataBase)

function NodeDefault:ctor(data)
    self.super.ctor(self, data)
end

return NodeDefault