local NodeFrame = class("NodeFrame")

local nf = NodeFrame
local d = display

function nf:ctor(data)
    dump(data, "-->data")
    self.width = data.width or 120
    self.height = data.height or 120
    self.view = cc.Node.create()
    self._data = data
    --
    self:_initGraph()
end


function nf:_initGraph()
    local color = cc.c4b(255, 255, 255, 255)
    self._bg = cc.LayerColor.create(color, 400,400)
    --self._bg:setContentSize(cc.size(400, 400))
    self.view:addChild(self._bg)

    local sp = cc.Sprite.create("texture/linePointSelect.png")
    self.view:addChild(sp)
    sp:setPositionX(200)
    sp:setPositionY(200)
    --
    ----tittle
    --local nickname = self._data["name"] or "unknow node"
    --
    --self._lab_title = d.labelL(nickname, d.DEFAULT_TTF_FONT, nil)
    --self._bg:addChild(self._lab_title)
    --local w, h = self._lab_title:size()
    --self._lab_title:pos(10, h - 10 - h/2)
    --
    ----line
    --local node_line = cc.DrawNode.create(2)
    --node_line:drawLine(cc.p(0, 0), cc.p(100, 100), cc.c4f(1, 1, 0.5, 1))
end

return nf