local BaseNode = class("BaseNode")
local Event = require("res/lib/event")
local ViewManager = require("res/render/viewmanager")
local enum = enum
local MEMORY = MEMORY

function BaseNode:ctor(data)
    self.data = data
    self.touchListener = null           -- 点击监听
    self.selectNode = null              -- 选中的节点（null/active=false 表示未选中）
    self.listNodePoint = {}

    local node = cc.Node.create()
    node:setAnchorPoint(cc.p(0.5, 0.5))
    self.view = node
end

function BaseNode:ShowName()
    if self.view then
        local lab = cc.Label.createWithTTF(self:getNameForType(), "font/FZLanTYJW.TTF", 15)
        self.view:addChild(lab)
        --lab:setString(self.__cname)
        local size = self.view:getContentSize()
        lab:setPositionX(size.width / 2)
        lab:setPositionY(size.height / 2)
        lab:setColor(cc.c3b(0,255,0))
    end
end
function BaseNode:getNameForType()
    if self.data then
        if self.data:getName() then
            return self.data:getName()
        end
    end
    return "default"
end

function BaseNode:setContentSize(size)
    if self.view then
        self.view:setContentSize(size)
    end
end
function BaseNode:getContentSize()
    if self.view then
        return self.view:getContentSize()
    end
    return null
end
function BaseNode:getPositionX()
    if self.view then
        return self.view:getPositionX()
    end
    return 0
end
function BaseNode:getPositionY()
    if self.view then
        return self.view:getPositionY()
    end
    return 0
end
function BaseNode:setPositionX(x)
    if self.view then
        self.view:setPositionX(x)
    end
end
function BaseNode:setPositionY(x)
    if self.view then
        self.view:setPositionY(x)
    end
end
function BaseNode:addPositionX(x)
    if self.view and x then
        self:setPositionX(x + self.view:getPositionX())
    end
end
function BaseNode:addPositionY(x)
    if self.view and x then
        self:setPositionY(x + self.view:getPositionY())
    end
end
function BaseNode:removeFromParentAndCleanup(cleanup)
    if self.view then
        self.view:removeFromParentAndCleanup(cleanup)
    end
end
function BaseNode:destroy()
    self:removeFromParentAndCleanup(true)
end
-- 是否选中
function BaseNode:isSelect()
    if self.selectNode and self.selectNode:isVisible() then
        return true
    end
    return false
end
-- 初始化 选中节点
function BaseNode:initSelectNode()
    if not self.selectNode then
        local node = cc.Sprite.create("texture/select.png")
        self.view:addChild(node)
        --local size = node:getContentSize()
        local sizeParent = self:getContentSize()
        node:setPositionX(sizeParent.width / 2)
        node:setPositionY(sizeParent.height / 2)
        self.selectNode = node
    end
end
-- 选中
function BaseNode:Select()
    self:initSelectNode()
    self.selectNode:setVisible(true)
end
-- 取消选中
function BaseNode:UnSelect()
    if self.selectNode then
        self.selectNode:setVisible(false)
    end
end
-- 反选
function BaseNode:ClickSelect()
    if self:isSelect() then
        self:UnSelect()
    else
        self:Select()
    end
end

function BaseNode:initTestPoint()
    local isShowParent = false
    local isShowChild = false
    if self:getType() == enum.enum_node_type.composites then
        isShowParent = true
        isShowChild = true
    elseif self:getType() == enum.enum_node_type.conditinals then
        isShowParent = true
        isShowChild = true
    elseif self:getType() == enum.enum_node_type.action then
        isShowParent = true
    end
    -- parent 节点
    if isShowParent then
        local size = self:getContentSize()
        local nodePoint = cc.Sprite.create("texture/point.png")
        self.view:addChild(nodePoint)
        nodePoint:setPositionX(size.width / 2 - 30)
        nodePoint:setPositionY(size.height - 8)
        self.listNodePoint[enum.dropnode_key.parent] = nodePoint
    end

    -- child 节点
    if isShowChild then
        local size = self:getContentSize()
        local nodePoint = cc.Sprite.create("texture/point.png")
        self.view:addChild(nodePoint)
        nodePoint:setPositionX(size.width / 2 + 30)
        nodePoint:setPositionY(8)
        self.listNodePoint[enum.dropnode_key.child] = nodePoint
    end

    --local size = self:getContentSize()
    --local nodePoint = cc.Sprite.create("texture/point.png")
    --self.view:addChild(nodePoint)
    --nodePoint:setPositionX(8)
    --nodePoint:setPositionY(size.height / 2)
    --self.listNodePoint[enum.dropnode_key.input] = nodePoint
    --
    --local size = self:getContentSize()
    --local nodePoint = cc.Sprite.create("texture/point.png")
    --self.view:addChild(nodePoint)
    --nodePoint:setPositionX(size.width - 8)
    --nodePoint:setPositionY(size.height / 2)
    --self.listNodePoint[enum.dropnode_key.output] = nodePoint
end
-- 是否可以开始拖动
function BaseNode:isCanDropStart(keyPoint)
    if keyPoint == enum.dropnode_key.parent then
        if true then
            
        end
    elseif keyPoint == enum.dropnode_key.child then

    end
    return true
end
-- 是否可以放置
function BaseNode:isCanDropIn(dropData, keyPointEnd)
    local nodeStart = dropData.nodeStart
    local keyPointStart = dropData.keyPoint
    return true
end
-- 获取放置节点的位置
function BaseNode:getDropPosForKey(key)
    if self.listNodePoint[key] then
        local dir = enum.node_direct.left
        local pos = self.listNodePoint[key]:getParent():convertToWorldSpace(cc.p(self.listNodePoint[key]:getPositionX(), self.listNodePoint[key]:getPositionY()))
        if key == enum.dropnode_key.parent then
            dir = enum.node_direct.top
        elseif key == enum.dropnode_key.child then
            dir = enum.node_direct.bottom
        elseif key == enum.dropnode_key.input then
            dir = enum.node_direct.left
        elseif key == enum.dropnode_key.output then
            dir = enum.node_direct.right
        end
        return pos, dir
    end
    return null, null
end

function BaseNode:setSwallowTouches(needSwallow)
    if self.touchListener then
        self.touchListener:setSwallowTouches(needSwallow);
    end
end

function BaseNode:getuuid()
    return self.data:getuuid()
end

function BaseNode:getData()
    return self.data
end

function BaseNode:getType()
    return self.data:gettype()
end

-- 点击相关
function BaseNode:registerTouch()
    local this = self
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(false);
    listener.onTouchBegan = function(touch, event)
        if not MEMORY.isCtrlDown then
            ViewManager:setAllNodeSwallowTouch(false)
            if ViewManager and ViewManager.isDropingLine then
                return true
            end
            for key, nodePoint in pairs(this.listNodePoint) do
                if nodePoint and this:isCanDropStart(key) then
                    local size = nodePoint:getContentSize()
                    if this.isTouchInsideNode(touch, nodePoint, size) then
                        local posStart, dirIn = this:getDropPosForKey(key)
                        local dropData = {
                            posStart = posStart,
                            posEnd = posStart,
                            keyPoint = key,
                            nodeStart = this,
                            dirIn = dirIn,
                        }
                        ViewManager:startDropingLine(dropData)
                        return true
                    end
                end
            end
        end


        local isTouch = this.isTouchSelf(touch, event)
        if isTouch then
            local target = event:getCurrentTarget()
            this._touchStart = target:getParent():convertToNodeSpace(touch:getLocation())
            this._pStartX = target:getPositionX()
            this._pStartY = target:getPositionY()
            return true
        end
        if not MEMORY.isCtrlDown then
            return true
        end
        return false
    end
    listener.onTouchMoved = function(touch, event)
        if ViewManager and ViewManager.isDropingLine then
            return true
        end

        if this._touchStart then
            if not this:isSelect() then
                -- 未选中 拖动自己
                local pos = touch:getLocation()
                local posStart = this._touchStart
                local target = event:getCurrentTarget()
                local posEnd = target:getParent():convertToNodeSpace(pos)
                target:setPositionX(this._pStartX + posEnd.x - posStart.x)
                target:setPositionY(this._pStartY + posEnd.y - posStart.y)

                Event:dispatchEvent({
                    name = enum.evt_keyboard.imgui_move_node_to_line,
                    list = {this},
                })

                return false
            else
                -- 选中 拖动所有已选中的点
                local pos = touch:getLocation()
                local posStart = this._touchStart
                local target = event:getCurrentTarget()
                local posEnd = target:getParent():convertToNodeSpace(pos)
                local offX = this._pStartX + posEnd.x - posStart.x - target:getPositionX()
                local offY = this._pStartY + posEnd.y - posStart.y - target:getPositionY()

                Event:dispatchEvent({
                    name = enum.evt_keyboard.imgui_move_node,
                    offX = offX,
                    offY = offY,
                })
            end
        end
        return false
    end
    listener.onTouchEnded = function(touch, event)

        if ViewManager and ViewManager.isDropingLine then

            for key, nodePoint in pairs(this.listNodePoint) do
                if nodePoint then
                    local size = nodePoint:getContentSize()

                    if this.isTouchInsideNode(touch, nodePoint, size) then
                        local dropData = {
                            keyPoint = key,
                            endNodeData = this,
                        }
                        if ViewManager:isCanDropEnd(dropData) then
                            ViewManager:endDropingLine(dropData)
                            return true
                        end
                    end
                end
            end
        end


        this._touchStart = null

        local isClick = this.isTouchSelf(touch, event)
        if isClick then
            if this.isClickForTouch(touch) then
                print("click node", this.data:getuuid())
                this:ClickSelect()
            end
            if not ViewManager.isDropingLine then
                ViewManager:setAllNodeSwallowTouch(true)
            end
        end

        return isClick
    end
    listener.onTouchCancelled = function(touch, event)
        if ViewManager and ViewManager.isDropingLine then
            return true
        end

        this._touchStart = null
        return false
    end
    local eventDispatcher = self.view:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.view);

    self.touchListener = listener
end
-- 是否点击自己
function BaseNode.isTouchSelf(touch, event)
    local target = event:getCurrentTarget()
    local size = target:getContentSize()
    if BaseNode.isTouchInsideNode(touch, target, size) then
        return true
    end
    return false
end
-- 是否在自己点击范围内
function BaseNode.isTouchInsideNode(pTouch,node,nodeSize)

    local pos = pTouch:getLocation()
    local point = node:convertToNodeSpace(pos)
    local x,y = point.x,point.y
    if x >= 0 and x <= nodeSize.width and y >= 0 and y <= nodeSize.height then
        return true
    end
end
-- 判断是否点击
function BaseNode.isClickForTouch(touch)
    local pEnd = touch:getLocation()
    local pStart = touch:getStartLocation()
    if math.abs(pStart.x - pEnd.x) < 10 and math.abs(pStart.y - pEnd.y) < 10 then
        return true
    end
    return false
end



return BaseNode