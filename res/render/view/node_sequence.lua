local NodeSequence = class("NodeSequence")

function NodeSequence:ctor()
    local node = cc.Sprite.create("texture/while.png")
    self.view = node
end

return NodeSequence