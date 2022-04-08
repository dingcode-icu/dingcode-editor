local BaseNode = class("BaseNode")
local Event = require("lib/event")
local ViewManager = require("render/viewmanager")
local theme = require("lib/theme")
local NodePointInput = require("render/common/nodepointinput")
local NodePointDefault = require("render/common/nodepoint_default")
local MenuInput = require("imguix/menu/menu_input")
local d = display
local enum = enum
local MEMORY = MEMORY

--枚举对应颜色
BaseNode.TYPE_COLOR = {
    [enum.enum_node_type.composites] = cc.c3b(255,255,204),
    [enum.enum_node_type.decorator] = cc.c3b(204,255,255),
    [enum.enum_node_type.conditionals] = cc.c3b(255,204,204),
    [enum.enum_node_type.action] = cc.c3b(153,204,204),
    [enum.enum_node_type.const] = cc.c3b(0,204,204),
    [enum.enum_node_type.root] = cc.c3b(0,204,204),
    ["unknown"] = cc.c3b(255,255,255)
}

BaseNode.STATE ={
    NORMAL = 1,
    SELECT = 2
}
local T_HEIGHT = 32  --字体大小

function BaseNode:ctor(data)
    self.data = data
    self.touchListener = null           -- 点击监听
    self._state  = BaseNode.STATE.NORMAL -- 是否选中状态
    self.listNodePoint = {}
    self.listStatePoint = {}            --  点的可选状态是否显示

    self.width = 0                       --节点的宽高
    self.height = 0
    self.view = nil
    self.sp_bg = nil                     --节点主要的背景，有选中鲜果 单独提出来
    self:initDefaultView()
    self:registerTouch()
end

function BaseNode:ShowName()
    if self.view then
        local lab = cc.Label.createWithTTF(self:getNameForType(), "font/FZLanTYJW.TTF", 15)
        self.view:addChild(lab)

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
function BaseNode:getParent()
    if self.view then
        return self.view:getParent()
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
    --print(BaseNode.STATE.SELECT)
    return self._state == BaseNode.STATE.SELECT
end
-- 初始化 选中节点
function BaseNode:initSelectNode()
    if self._state == BaseNode.STATE.NORMAL then
        local out_state =  ShaderMgr:getInc():getEffect("outline")
        self.sp_bg:setGLProgramState(out_state)
    end
end
-- 选中
function BaseNode:Select()
    self:initSelectNode()
    self._state = BaseNode.STATE.SELECT
end
-- 取消选中
function BaseNode:UnSelect()
    if self:isSelect() then
        print("load unselect")
        local state = cc.GLProgramState.getOrCreateWithGLProgramName(cc.GLProgramStateE.SHADER_NAME_POSITION_TEXTURE_COLOR_NO_MVP)
        self.sp_bg:setGLProgramState(state)
        self._state = BaseNode.STATE.NORMAL
    end
end
-- 反选
function BaseNode:ClickSelect()
    print(self:isSelect(), "-->>isselect")
    if self:isSelect() then
        self:UnSelect()
    else
        print('a13123123')
        self:Select()
    end
end
---使用默认节点表现初始化,
---通用节点内置节点都由此实现,
---当有特殊表现逻辑时，单独通过复写initView处理
---@return nil
function BaseNode:initDefaultView()
    if self.initView then
        self:initView()
        return
    end
    --root
    local root = cc.Node.create()
    self.view = root
    root:setAnchorPoint(cc.p(0.5, 0.5))
    local w = string.len(self.data:getName()) *T_HEIGHT/2
    self.width = w < 120 and 120 or w
    self.height = 120
    self.color = BaseNode.TYPE_COLOR[self:getType()] or BaseNode.TYPE_COLOR["unknown"]
    root:setContentSize(cc.size(self.width, self.height))
    --bg
    local sp_bg = cc.Scale9Sprite.create(theme.texture("bg_frame.png"))
    sp_bg:setContentSize(cc.size(self.width, self.height))
    sp_bg:setOpacity(170)
    sp_bg:setPosition(self.width / 2, self.height / 2)
    self.sp_bg = sp_bg


    --tittle
    local sp_tbg = cc.Scale9Sprite.create(theme.texture("bg_frame.png"))
    sp_tbg:setContentSize(cc.size(self.width, T_HEIGHT))
    sp_tbg:setPosition(cc.p(self.width / 2,  self.height - T_HEIGHT / 2))
    sp_tbg:setColor(self.color)

    local lab_title = d.labelL(self.data:getName(), d.DEFAULT_TTF_FONT, nil)
    lab_title:pos(self.width / 2, T_HEIGHT / 2)
    lab_title:setColor(d.COLOR_BLACK)

    --[[dev]]
    if RELEASE.IS_BASENODE_DEBUGGRAPH then
        local lab_dev = d.labelL(self:getuuid(), d.DEFAULT_TTF_FONT, nil)
        lab_dev:pos(self.width,  T_HEIGHT / 2)
        lab_dev:setFontSize(20)
        lab_dev:setColor(d.COLOR_YELLOW)
        sp_tbg:addChild(lab_dev)
    end


    --point
    self:initTreePoint()
    root:addChild(sp_bg)
    sp_bg:addChild(sp_tbg)
    sp_tbg:addChild(lab_title)

end
---创建层级逻辑关系节点表现
---@return nil
function BaseNode:initTreePoint()
    local isShowParent = false
    local isShowChild = false
    local tp = self:getType()
    if tp == enum.enum_node_type.composites then
        isShowParent = true
        isShowChild = true
    elseif tp == enum.enum_node_type.conditionals then
        isShowParent = true
    elseif tp == enum.enum_node_type.action then
        isShowParent = true
    elseif tp == enum.enum_node_type.root then
        isShowChild = true
    elseif tp == enum.enum_node_type.decorator then
        isShowParent = true
    end
    -- parent 节点
    if isShowParent then
        local sp_p = cc.Sprite.create(theme.texture("triangle.png"))
        sp_p:setPosition(self.width / 2, self.height + 8)
        self.view:addChild(sp_p)
        self.listNodePoint[enum.dropnode_key.parent] = sp_p
    end

    -- child 节点
    if isShowChild then
        local sp_p = cc.Sprite.create(theme.texture("triangle.png"))
        sp_p:setPosition(self.width / 2, - 8)
        sp_p:setScale(1, -1)
        self.view:addChild(sp_p)
        self.listNodePoint[enum.dropnode_key.child] = sp_p
    end
    self:initInOutPoint()
end
function BaseNode:isPointSelect(key)
    if not self.listStatePoint[key] then
        self.listStatePoint[key] = BaseNode.STATE.NORMAL
    end
    return self.listStatePoint[key] == BaseNode.STATE.SELECT
end
function BaseNode:setPointstate(key, isSelect)
    if isSelect then
        self.listStatePoint[key] = BaseNode.STATE.SELECT
    else
        self.listStatePoint[key] = BaseNode.STATE.NORMAL
    end
end
---切换tree-point节点的显示状态
function BaseNode:selTreePoint(dk, iss)
    local sp = self.listNodePoint[dk]
    if sp then
        if iss ~= self:isPointSelect(dk) then
            if dk == enum.dropnode_key.parent or dk == enum.dropnode_key.child then
                local tp = iss and theme.texture("circle.png") or theme.texture("triangle.png")
                sp:setTexture(tp)
            else
                sp:select(iss)
            end
        end
        -- 维护内存数据
        self:setPointstate(dk, iss)
    end
end
function BaseNode:newNodePoint(data)
    local node = nil
    if data.keyconfig and (data.keyconfig.key == enum.dropnode_key.input_int or data.keyconfig.key == enum.dropnode_key.input_float or data.keyconfig.key == enum.dropnode_key.input_text) then
        node = NodePointInput.new(data)
    else
        node = NodePointDefault.new(data)
    end
    return node
end
function BaseNode:initInOutPoint()
    local listinput = self:getData():getListInputConfig()
    if listinput then
        local i = 0
        for key, v in pairs(listinput) do
            i = i + 1
            local data = {
                parent = self,
                key = key,
                keyconfig = v,
            }

            local nodein = self:newNodePoint(data)
            self.view:addChild(nodein.view)
            nodein.view:setAnchorPoint(cc.p(0.5, 0.5))
            nodein.view:setPositionX(20)
            nodein.view:setPositionY(self.height - (50 + (i - 1) * 20))
            self.listNodePoint[key] = nodein
        end
    end

    local listoutput = self:getData():getListOutputConfig()
    if listoutput then
        local i = 0
        for key, v in pairs(listoutput) do
            i = i + 1
            local data = {
                parent = self,
                key = key,
                keyconfig = v,
            }

            local nodein = self:newNodePoint(data)
            self.view:addChild(nodein.view)
            nodein.view:setAnchorPoint(cc.p(0.5, 0.5))
            nodein.view:setPositionX(self.width - 20)
            nodein.view:setPositionY(self.height - (50 + (i - 1) * 20))
            self.listNodePoint[key] = nodein
        end
    end
end
-- 是否可以开始拖动
function BaseNode:isCanDropStart(keyPoint)
    if keyPoint == enum.dropnode_key.parent then
        if self:getType() == enum.enum_node_type.composites or
            self:getType() == enum.enum_node_type.conditionals or
            self:getType() == enum.enum_node_type.decorator
        then
            -- 只能有一个父节点
            if #self:getData():getParentIdList() >= 1 then
                return false
            else
                return true
            end
        elseif self:getType() == enum.enum_node_type.action then
            -- 可以有多个父节点
            return true
        else
            return true
        end
    elseif keyPoint == enum.dropnode_key.child then
        if self:getType() == enum.enum_node_type.composites then
            -- 可以有多个子节点
            return true
        elseif self:getType() == enum.enum_node_type.conditionals or self:getType() == enum.enum_node_type.root then
            -- 只能有一个子节点
            if #self:getData():getChildIdList() >= 1 then
                return false
            else
                return true
            end
        elseif self:getType() == enum.enum_node_type.action then
            -- 不可以有子节点
            return false
        end
    else
        -- 默认 在可拖动配对数组内的， 只能放置一个
        for i, v in pairs(enum.dropkey_canset) do
            -- 判断类型
            local config = self:getData():getConfigForKey(keyPoint)
            if config then
                if self:isKeyInList(v, config.key) then
                    --判断数量是否可以拖动
                    if #self:getData():getLineIdList(keyPoint) < config.numMax then
                        -- 默认只能和一个连接
                        return true
                    end
                end
            end
        end
    end
    return false
end
-- key 是否是不相等的 并且处于列表
function BaseNode:isKeyInList(list, key1)
    if (key1 == list[1]) or (key1 == list[2]) then
        return true
    end
    return false
end
-- 是否可以放置
function BaseNode:isCanDropIn(dropData, keyPointEnd)
    local nodeStart = dropData.nodeStart
    local keyPointStart = dropData.keyPoint
    local nodeEnd = self
    local keyTypeStart = keyPointStart
    local keyTypeEnd = keyPointEnd
    if nodeStart:getuuid() == nodeEnd:getuuid() then
        -- 自己不能和自己相连
        return false
    end
    if keyTypeStart ~= enum.dropnode_key.child and keyTypeStart ~= enum.dropnode_key.parent then
        local config = nodeStart:getData():getConfigForKey(keyTypeStart)
        if config then
            keyTypeStart = config.key
        end
    end
    if keyTypeEnd ~= enum.dropnode_key.child and keyTypeEnd ~= enum.dropnode_key.parent then
        local config = nodeEnd:getData():getConfigForKey(keyTypeEnd)
        if config then
            keyTypeEnd = config.key
        end
    end
    for i, v in pairs(enum.dropkey_canset) do
        -- 判断类型
        if self:isKeyInListNotSame(v, keyTypeStart, keyTypeEnd) then
            --判断数量是否可以放
            if self:isCanDropStart(keyPointEnd) then
                -- 判断是否已经包含
                if not nodeStart:getData():isContainForLineList(keyPointStart, nodeEnd:getuuid(), keyPointEnd) then
                    return true
                end
            end
        end
    end
    return false
end
-- key 是否是不相等的 并且处于列表
function BaseNode:isKeyInListNotSame(list, key1, key2)
    if (key1 == list[1] and key2 == list[2]) or (key2 == list[1] and key1 == list[2]) then
        return true
    end
    return false
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
        else
            local config = self:getData():getConfigForKey(key)
            if config and config.direct then
                dir = config.direct
            end
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
        ViewManager:setAllNodeSwallowTouch(false)
        if not MEMORY.isCtrlDown then

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
        if isTouch and not ViewManager.isDropingNode then
            ViewManager.isDropingNode = true
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
            for key, nodePoint in pairs(this.listNodePoint) do
                if nodePoint then
                    local size = nodePoint:getContentSize()
                    if this.isTouchInsideNode(touch, nodePoint, size) then
                        local dropData = {
                            keyPoint = key,
                            endNodeData = this,
                        }
                        if ViewManager:isCanDropEnd(dropData) then
                            this:selTreePoint(key, true)
                        else
                            this:selTreePoint(key, false)
                        end
                    else
                        this:selTreePoint(key, false)
                    end
                end
            end

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

                return true
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
                return true
            end
        end
        return false
    end
    listener.onTouchEnded = function(touch, event)

        if ViewManager and ViewManager.isDropingLine then

            for key, nodePoint in pairs(this.listNodePoint) do
                if nodePoint then

                    this:selTreePoint(key, false)

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

        -- 判断 按钮上的点击事件
        for key, nodePoint in pairs(this.listNodePoint) do
            if nodePoint and not this:isCanDropStart(key) then
                local size = nodePoint:getContentSize()
                if this.isTouchInsideNode(touch, nodePoint, size) and nodePoint.getConfigKey then
                    local keyConfig = nodePoint:getConfigKey()
                    if keyConfig == enum.dropnode_key.input_int or keyConfig == enum.dropnode_key.input_float or keyConfig == enum.dropnode_key.input_text then
                        Event:dispatchEvent({
                            name = enum.evt_keyboard.imgui_menu_input,
                            finishFunc = function(lab)
                                nodePoint:setValue(lab)
                            end,
                            typeinput = keyConfig,
                            valueOld = nodePoint:getValue(),
                        })
                    end

                    if not ViewManager.isDropingLine then
                        ViewManager:setAllNodeSwallowTouch(true)
                    end
                    return true
                end
            end
        end

        local isClick = this.isTouchSelf(touch, event)
        if isClick and this._touchStart then
            if this.isClickForTouch(touch) then
                print("click node", this.data:getuuid())
                this:ClickSelect()
                -- 刷新详情页
                Event:dispatchEvent({
                    name = enum.evt_keyboard.imgui_menu_detail,
                    isRefresh = true,
                    uuid = this:getuuid()
                })
            else
                ViewManager:addHistoryToList()
            end
            if not ViewManager.isDropingLine then
                ViewManager:setAllNodeSwallowTouch(true)
            end
        end

        this._touchStart = null
        ViewManager.isDropingNode = false

        return isClick
    end
    listener.onTouchCancelled = function(touch, event)
        if ViewManager and ViewManager.isDropingLine then
            return true
        end

        this._touchStart = null
        ViewManager.isDropingNode = false

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


-- 设置 调试模式的状态
function BaseNode:setDebugState(state)

    if not self.sprDebugState and state ~= enum.debug_state.none then
        --local sp_p = cc.Sprite.create(theme.texture("running.png"))
        local sp_p = cc.Sprite.create()
        sp_p:setPosition(self.width / 2, self.height / 2)
        sp_p:setScale(0.4)
        self.view:addChild(sp_p)
        self.sprDebugState = sp_p
    end

    if state == enum.debug_state.none then
        if self.sprDebugState then
            self.sprDebugState:setVisible(false)
        end
    elseif state == enum.debug_state.runing then
        if self.sprDebugState then
            self.sprDebugState:setVisible(true)
            self.sprDebugState:setTexture(theme.texture("running.png"))
        end
    elseif state == enum.debug_state.success then
        if self.sprDebugState then
            self.sprDebugState:setVisible(true)
            self.sprDebugState:setTexture(theme.texture("success.png"))

        end
    elseif state == enum.debug_state.fail then
        if self.sprDebugState then
            self.sprDebugState:setVisible(true)
            self.sprDebugState:setTexture(theme.texture("fail.png"))
        end
    elseif state == enum.debug_state.endrun then
        if self.sprDebugState then
            self.sprDebugState:setVisible(true)
            self.sprDebugState:setTexture(theme.texture("end.png"))
        end
    else
        print("setDebugState error, state = ", state)
    end
end

return BaseNode