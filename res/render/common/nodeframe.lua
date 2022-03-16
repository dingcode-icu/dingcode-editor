local NodeFrame = class("NodeFrame")

local nf = NodeFrame
local d = display
local T_HEIGHT = 32  --字体大小
local theme = require("lib/theme")




function nf:ctor(data)
    self:_chkData(data)
    self.view = cc.Node.create()
    self:_initGraph()
end


function nf:_initGraph()

end


function nf:_chkData(data)
    data["name"] = data["name"] or "unknown-name"
    data["type"] = data["type"] or "unknown"
    self.width = string.len(data.name) * T_HEIGHT/2 < 120 and 120 or string.len(data.name) * T_HEIGHT/2
    self.height = 120
    self.color = NodeFrame.TYPE_COLOR[data["type"]]

    self.is_p = data[""]
    self._data = data
end

return nf