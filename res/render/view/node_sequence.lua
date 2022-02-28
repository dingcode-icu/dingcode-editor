local NodeActive = class("NodeActive")

function NodeActive:ctor()
    local node = cc.Sprite.create("texture/while.png")
    self.view = node
end

return NodeActive