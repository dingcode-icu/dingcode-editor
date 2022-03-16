--==================================
-- display扩展
--==================================
local d = display
--===========================================================================
--default params for show
local type = type
local math = math
local table= table
d.CCUI_ISABLE = true        --是否全使用ccui的控件。。。UIButton etc.
--===========================================================================

--[[锚点位置]]
local ALIGN_TAG = {"C", "L", "T", "B", "R", "LT", "RT", "LB", "RB"}
local ALIGN_ANCHOR = {cc.p(0.5, 0.5), cc.p(0, 0.5), cc.p(0.5, 1), cc.p(0.5, 0), cc.p(1, 0.5), cc.p(0, 1), cc.p(1, 1), cc.p(0, 0), cc.p(1, 0)}

local Node = cc.Node
for idx, _align in ipairs(ALIGN_TAG) do --labels
    if (_align) ~= "" then
        Node["align".._align] = function(self)
            self:setAnchorPoint(ALIGN_ANCHOR[idx])
            return self
        end
    end
end
function Node:size(w, h)
    if not w then
        local size = self:getContentSize()
        return size.width , size.height
    elseif w and not h then
        self:setContentSize(w , w)
    else
        self:setContentSize(w , h)
    end
    return self
end

function Node:pos(x, y)
    if x and y then
        self:setPosition(x, y)
    elseif x and not y then
        self:setPosition(x , x)
    elseif x and y and z then
        self:setPosition3D(cc.vec3(x , y , z))
    else
        return self:getPosition()
    end
    return self
end

function Node:getAnchor()
    local anp = self:getAnchorPoint()
    return anp.x, anp.y
end

function Node:setAnchor(x, y)
    self:setAnchorPoint(cc.p(x, y))
    return self
end

function Node:clear()
    self:removeFromParent()
end

function Node:scale(sx ,sy ,sz)
    if not sx then
        return self:getScale()
    elseif sx and not sy then
        self:setScale(sx , sx)
    elseif sx and sy and sz then
        self:setScale(sx , sy)
        self:setScaleZ(sz)
    else
        self:setScale(sx , sy)
    end
    return self
end

function Node:schedule(callback, interval)
    local seq = transition.sequence({
        cc.DelayTime:create(interval),
        cc.CallFunc:create(callback),
        nil
    })
    local action = cc.RepeatForever:create(seq)
    self:runAction(action)
    return action
end

function Node:delayCall(callfunc , delaytime)
    delaytime = delaytime or 0
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(delaytime),
        cc.CallFunc:create(callfunc)
        ))
    return self
end

function Node:find(childname)
    local treelist = string.split(childname, ".")
    if #treelist == 1 then
        return self:getChildByName(treelist[1])
    end
    local tmpnode
    for _, child in ipairs(treelist) do
        tmpnode = self:getChildByName(child)
    end
    return tmpnode
end

function Node:rotate3d(rx , ry , rz)
    self:setRotation3D(cc.vec3(rx , ry , rz))
    return self
end

function Node:setTap(handler)
    local w, h = self:size()
    local ax, ay = self:getAnchor()
    if not self._bindBtnnode then
        self._bindBtnnode = d.btnNode(w, h):size(w, h):setAnchor(ax, ay):addTo(self):pos((ax - 0) * w, (ay - 0) * h)
    end
    self._bindBtnnode:setTap(handler)
    return self
end

function Node:setEnabled(val)
    if not tolua.isnull(self._bindBtnnode) then
        self._bindBtnnode:setTouchEnabled(val)
    end
end


--[[默认字体]]
d.DEFAULT_TTF_FONT = nil

--[[默认的点击缩放大小]]
d.DEFAULT_BTN_PRESS_SCALE = -0.1

--[[scroll方向]]
d.Direction = {NONE = 0, VERTICAL = 1, HORIZONTAL = 2, BOTH = 3}

--[[颜色扩充]]
d.COLOR_YELLOW = cc.c3b(255, 255, 0) -- 黄色
d.COLOR_GRAY = cc.c3b(120, 120, 120) -- 灰色

d.w, d.h = d.width, d.height
--===========================================================================

d.director = cc.Director:getInstance()
d.glview = d.director:getOpenGLView()

d.textureCache = d.director:getTextureCache()
d.spriteFrameCache = cc.SpriteFrameCache:getInstance()
d.animationCache = cc.AnimationCache:getInstance()

d.scheduler = d.director:getScheduler()
d.fileUtils = cc.FileUtils:getInstance()
d.userDef   = cc.UserDefault:getInstance()
--node
d.node = d.newNode

--csb-node
d.csbNode = function(csbfile, action)
    if not d.fileUtils:isFileExist(csbfile) then
        return d.node()
    else
        local csbnode = cc.CSLoader:createNode(csbfile)
        if type(action) == "string" then
            local ani = cc.CSLoader:createTimeline(csbfile)
            ani:play(action, true)
            csbnode:runAction(ani)
        end
        return csbnode
    end
end

--sprite
d.sp = function(...)
    local params = {...}
    if #params == 0 then
        return d.newSprite()
    else
        return d.newSprite(...)
    end
end

--sprite9
d.sp9 = function(texturefile, width, height, rect, capInsets)
    if not width then
        return d.sp(texturefile)
    end
    return d.sp(texturefile, 0, 0,  {scale9   = true,
                                     rect     = rect or cc.rect(0, 0, 0, 0),
                                     size     = {width = width or 0, height = height or 0},
                                     capInsets = capInsets or cc.rect(0, 0, 0, 0)
                                }
                            )
end

--cover
d.cover = function(node, color, w, h, handler)
    local _w, _h = w, h
    local anp = node:getAnchorPoint()
    local layer = d.colorlayer(color, _w, _h):addTo(node):pos(-_w/2, -_h/2)
    local btnnode = d.btnNode(_w, _h):addTo(layer)
    if handler and type(handler) == "function"  then
        btnnode:setTap(handler)
    end
    return layer
end

--cover
d.coverAll = function(node, color, callback)
    local anp = node:getAnchorPoint()
    local layer = d.colorlayer(color):addTo(node)--:pos(-d.w, -d.h)
    layer:setAnchorPoint(0.5, 0.5)
    local function onTouchBegan(touch, event)
        if callback then
            callback()
        end
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
    layer._listener_ = listener
    return layer
end

--frame ani
d.frameAni = function(aniname, actname, framenum, intertime)
    local index = 0
    local framename
    local frames = {}
    for i = 1, framenum do
        index = index + 1
        framename = aniname .. '_' .. actname .. '_' .. string.format("%02d", index) .. '.png'
        frames[i] = d.spriteFrameCache:getSpriteFrame(framename)
    end
    local animMixed = cc.Animation:createWithSpriteFrames(frames, intertime)
    return cc.Animate:create(animMixed)
end

--spriteFrame ani
d.spAnimation = function(aniname, intertime)
    local index = 0
    local framename
    local framenum = 999
    local frames = {}
    for i = 1, framenum do
        index = index + 1
        framename = aniname .. '_' .. index .. '.png'
        local frameSP = d.spriteFrameCache:getSpriteFrame(framename)
        if frameSP then
            frames[i] = frameSP
        else
            break
        end
    end
    if #frames < 1 then
        return nil
    end
    local animMixed = cc.Animation:createWithSpriteFrames(frames, intertime)
    return cc.Animate:create(animMixed)
end

--scene
d.scene = d.newScene

--layer
d.layer = d.newLayer

--colorlayer
d.colorlayer = function(color, width, height)
    local ret = d.layer(color)
    if width and height then
        ret:size(width, height)
    end
    return ret
end

--graidlayer
d.graidlayer = function(colorstar, colorend, width, height)
    local ret = d.layer(colorstar, colorend)
    if width and height then
        ret:size(width, height)
    end
    return ret
end

--drawnode
d.drawcircle = function(radius, color)
    local dnode = cc.DrawNode:create()
    dnode:drawDot(cc.p(0, 0), radius, color)
    return dnode
end

d.drawovalcircle = function(radius, color, sclx, scly)
    local dnode = cc.DrawNode:create()
    local raduis = radius --半径
    local edge = 50 --弧度切割片段

    dnode:drawSolidCircle(cc.p(raduis, raduis * scly / sclx), raduis, math.pi / 2, 50, sclx, scly, color)
    return dnode
end

d.drawunderline = function(labelobj, color)
    local w, h = labelobj:size()
    local anchor = labelobj:getAnchor()
    local dnode = cc.DrawNode:create()
    local starpos = cc.p(0, 0)
    local endpos = cc.p(w, 0)
    dnode:drawSegment(starpos, endpos, 1, color)
    labelobj:addChild(dnode)
end

--clip node
d.clippingNode = function(w, h)
    local ret = cc.ClippingNode:create()
    local stencil = d.sp9("alpha.png", w, h):alignLB():addTo(ret)
    ret:setStencil(stencil)
    return ret
end

--clip circle
d.clippingCircle = function(x, y, c4bcolor)
    local ret = cc.ClippingNode:create()
    d.colorlayer(c4bcolor):addTo(ret)
    local stencil = d.sp("alpha.png"):alignLB():addTo(ret):pos(x, y)
    ret:setStencil(stencil)
    ret:setInverted(true)
    ret:setAlphaThreshold(0)
    return ret
end

--clip rect
d.clippingRect = function(x, y, w, h, c4bcolor)
	local node_clip = display.clippingNode (w, h):pos(x, y)
	local layer_color = display.colorlayer(c4bcolor, d.w*w, d.h*2):addTo(node_clip):pos(-d.w, -d.h)
    node_clip:setInverted(true)
    return node_clip
end

--clip 圆角rect
d.clippingRoundRect =function(x, y, w, h, radius, c4bcolor)
    local rect = cc.rect(x, y, w, h)
    local segments    = 100
    local origin      = cc.p(rect.x, rect.y)
    local destination = cc.p(rect.x + rect.width, rect.y + rect.height)
    local points      = {}

    -- 算出1/4圆
    local coef     = math.pi / 2 / segments
    local vertices = {}

    for i=0, segments do
        local rads = (segments - i) * coef
        local x    = radius * math.sin(rads)
        local y    = radius * math.cos(rads)

        table.insert(vertices, cc.p(x, y))
    end

    local tagCenter      = cc.p(0, 0)
    local minX           = math.min(origin.x, destination.x)
    local maxX           = math.max(origin.x, destination.x)
    local minY           = math.min(origin.y, destination.y)
    local maxY           = math.max(origin.y, destination.y)
    local dwPolygonPtMax = (segments + 1) * 4
    local pPolygonPtArr  = {}

    -- 左上角
    tagCenter.x = minX + radius;
    tagCenter.y = maxY - radius;

    for i=0, segments do
        local x = tagCenter.x - vertices[i + 1].x
        local y = tagCenter.y + vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右上角
    tagCenter.x = maxX - radius;
    tagCenter.y = maxY - radius;

    for i=0, segments do
        local x = tagCenter.x + vertices[#vertices - i].x
        local y = tagCenter.y + vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右下角
    tagCenter.x = maxX - radius;
    tagCenter.y = minY + radius;

    for i=0, segments do
        local x = tagCenter.x + vertices[i + 1].x
        local y = tagCenter.y - vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 左下角
    tagCenter.x = minX + radius;
    tagCenter.y = minY + radius;

    for i=0, segments do
        local x = tagCenter.x - vertices[#vertices - i].x
        local y = tagCenter.y - vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    local node_clip = cc.ClippingNode:create()
	local layer_color = display.colorlayer(c4bcolor, d.w*w, d.h*2):addTo(node_clip):pos(-d.w, -d.h)
    local stencil = cc.DrawNode:create()
    stencil:drawPolygon(pPolygonPtArr, #pPolygonPtArr, cc.c3b(255, 255, 255), 1, c4bcolor)
    node_clip:setStencil(stencil)
    node_clip:setInverted(true)
    return node_clip
end

--progressTime(Horizontal)
d.progressHor = function(tfile)
    local pt = cc.ProgressTimer:create(d.sp(tfile))
    pt:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    return pt
end

--progressTime(Vertical)
d.progressVer = function(tfile)
    local pt = cc.ProgressTimer:create(d.sp(tfile, "vertical"))
    pt:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    return pt
end

d.ccuiPageView = function (w, h, direction)
    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    local dirc = direction == d.Direction.VERTICAL and ccui.ScrollViewDir.vertical or ccui.ScrollViewDir.horizontal
    pageView:setDirection(dirc)
    pageView:setContentSize(cc.size(w, h))

    function pageView:_updateProp(idx)
        local problist = self._proplist
        local pobj
        local infname = string.sub(self._intext, 2)
        local outname = string.sub(self._outext, 2)
        for i, prop in ipairs(problist) do
            pobj = problist[i]
            if (pobj and tolua.isnull(pobj) == false and tolua.isnull(self) == false and infname) then
                local frame = nil
                if idx == i then
                    frame = d.spriteFrameCache:getSpriteFrame(infname)
                else
                    frame = d.spriteFrameCache:getSpriteFrame(outname)
                end
                if not tolua.isnull(frame) then
                    pobj:setSpriteFrame(frame)
                end
            end
        end
    end

    --创建下方的监听点
    function pageView:crtScrollProp(num, intexture, outtexture, dis)
        dis = dis or 100
        local node = d.node()
        self._proplist = {}
        self._intext = intexture
        self._outext = outtexture

        for i = 1, num do
            table.insert(self._proplist, d.sp(intexture):addTo(node):pos((i - 1)* dis, 0))
        end

        local update = function()
            local index = self:getCurrentPageIndex()
            if self.curPageIndex ~= index then
                self.curPageIndex = index
                self:_updateProp(self.curPageIndex+1)
            end

            local point = self:getInnerContainerPosition()
            if point.x % w == 0 and self.pageChangeIndx ~= index and self.pageChange then
                self.pageChangeIndx = index
                self.pageChange(index+1)
            end

            if self.scrollEvent then
                local point = self:getInnerContainerPosition()
                self.scrollEvent(point.x % w ~= 0)
            end
        end

        self.curPageIndex = -1
        self.pageChangeIndx = self.curPageIndex
        self:schedule(update, 0.1)
        self:_updateProp(1)
        return node
    end

    function pageView:setOnScroll(scrollEvent)
        self.scrollEvent = scrollEvent
    end

    function pageView:setOnPageChange(pageChange)
        self.pageChange = pageChange
    end

    return pageView
end

--scroll
d.scrollHor = function(w, h, cont, contlen)
    local scroll = ScrollBase.new(w, h, 2)
    scroll:setView(cont, contlen, h)

    function scroll:_updateProp(idx)
        local problist = self._proplist
        local pobj
        local infname = string.sub(self._intext, 2)
        local outname = string.sub(self._outext, 2)
        for i, prop in ipairs(problist) do
            pobj = problist[i]
            if (pobj and tolua.isnull(pobj) == false and tolua.isnull(self) == false and infname) then
                if idx == i then
                    frame = d.spriteFrameCache:getSpriteFrame(infname)
                else
                    frame = d.spriteFrameCache:getSpriteFrame(outname)
                end
                if not tolua.isnull(frame) then
                    pobj:setSpriteFrame(frame)
                end
            end
        end
    end

    --创建下方的监听点
    function scroll:crtScrollProp(num, intexture, outtexture, dis)
        dis = dis or 100
        local node = d.node()
        self._proplist = {}
        self._intext = intexture
        self._outext = outtexture

        for i = 1, num do
            table.insert(self._proplist, d.sp(intexture):addTo(node):pos((i - 1)* dis, 0))
        end

        local onContOff = function()
            local curidx = self:getCurrUnitIdx()
            self:_updateProp(curidx)
        end
        self:setContentOffsetCallBack(onContOff)
        --update now
        self:_updateProp(scroll:getCurrUnitIdx())
        return node
    end
    return scroll
end

d.scrollVec = function(w, h, cont, contlen)
    local scroll = ScrollBase.new(w, h, 1)
    scroll:setView(cont, w, contlen)
    return scroll
end

--pageview
d.pageView = function(w, h, direction, createfunc, params)
    if d.CCUI_ISABLE then
        local dirc = (direction == d.Direction.HORIZONTAL and cc.TABLEVIEW_FILL_TOPDOWN)
                    or cc.TABLEVIEW_FILL_BOTTOMUP
        local pobj = cc.TableView:create(cc.size(w, h))
        pobj:setDirection(dirc)
        pobj:setDelegate()

        pobj.cellSize = function()
            return params["cellw"], params["cellh"]
        end

        pobj.cellKeepNum = function()
            return params["keepcnt"]
        end

        pobj.onTouchCell_ = function(table, cell)
        end

        pobj.onScroll_ = function()
            -- luaex.func_hook(pobj, "onScroll")
        end

        pobj.onScrollZomm_ = function()
            -- luaex.func_hook(pobj, "onScrollZoom")
        end

        pobj.onPageChg_ = function()
            -- luaex.func_hook(pobj, "onPageChange")
        end

        pobj.cellCreateFunc_ = function(table, idx)

            -- luaex.func_hook(pobj, "cellCreateFunc", table, idx)
            return cell
        end

        pobj:registerScriptHandler(pobj.cellKeepNum,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        pobj:registerScriptHandler(pobj.cellSize,cc.TABLECELL_SIZE_FOR_INDEX)
        pobj:registerScriptHandler(createfunc,cc.TABLECELL_SIZE_AT_INDEX)

        pobj:registerScriptHandler(pobj.onScroll_ ,cc.SCROLLVIEW_SCRIPT_SCROLL)
        pobj:registerScriptHandler(pobj.onScrollZomm_,cc.SCROLLVIEW_SCRIPT_ZOOM)
        pobj:registerScriptHandler(pobj.onTouchCell_,cc.TABLECELL_TOUCHED)

        pobj:reloadData()

        return pobj
    end
end

--widgets
d.btnNode = function(...)
    return BtnNode.new(...)
end
d.btnSp = function(...)
    if d.CCUI_ISABLE  then
        local params = {...}
        local btn = ccui.Button:create(params[1], params[2] or "", params[3] or "", params[4] or ccui.TextureResType.plistType)
        btn:setPressedActionEnabled(true)
        btn:setZoomScale(d.DEFAULT_BTN_PRESS_SCALE)

        function btn:disableAct()
            btn:setPressedActionEnabled(false)
            btn:setZoomScale(0)
            return self
        end
        return btn
    else
        local btnsp = BtnSp.new(...)
        if uihall and uihall["ShaderMgr"] then
            local shadow = uihall.ShaderMgr:getCustomShader("shadow")
            btnsp:setGLShadow(shadow)
        end
        return btnsp
    end
end
d.btnLabel = function(...)
    return BtnLabel.new(...)
end
--=====================node align=====================
local Node = cc.Node

--labels
d.label = nil
d.labelL = nil
d.labelT = nil
d.labelB = nil
d.labelR = nil
d.labelLT = nil
d.labelRT = nil
d.labelLB = nil
d.labelRB = nil
d.DEFAULT_TTF_FONT_SIZE = 24
for idx, _align in ipairs(ALIGN_TAG) do --labels

    d["label" .. _align] = function(v, ttf, fontsize, color, width, align)
        local ret
        if not ttf then
            ret = cc.Label:createWithSystemFont(v, "arial", fontsize or d.DEFAULT_TTF_FONT_SIZE)
            if width then
                ret:setWidth(width)
            end
        else
            local size =  fontsize or d.DEFAULT_TTF_FONT_SIZE
            local ff = ttf
            ret = cc.Label.createWithTTF(v, ff,
                size)
        end
        return ret
    end
end
d.label = d.labelC

d.bmfont = function(str, fontfile, width)
    width = width or d.width
    return cc.LabelBMFont:create(str, fontfile, width)
end

--event
d.eventDispatcher = function(target)
    return target:getEventDispatcher()
end

--=====================HelpFunc=====================
--return {numver}
--two node distance
d.getNodeWorldDis = function(node1, node2)
    local nowscene = d.director:getRunningScene()

    local p0 = cc.p(0, 0)
    local p1 = node1:convertToWorldSpace(p0)
    local p2 = node2:convertToWorldSpace(p0)

    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    local disy = math.abs(y2 - y1)
    local disx = math.abs(x2 - x1)
    return math.sqrt(disy ^ 2 + disx ^ 2)
end

d.getPointWorldDis = function(p1, p2)
    local disx = math.abs(p2.x - p1.x)
    local disy = math.abs(p2.y - p1.y)
    return math.sqrt(disx ^ 2 + disy ^ 2)
end

--[[创建一个富文本
@fontSize 字号
@maxWidth 宽度
@str 文本信息(按照富文本的格式) 可选
@lineHeight 行高 默认与字号一致
@defaultColor 默认文本颜色 默认白色
@return node 富文本节点
]]
d.labelRtf = function (str, ttf, fontSize, color, maxWidth, lineHeight)
    ttf = ttf or d.DEFAULT_TTF_FONT
    fontSize = fontSize or d.DEFAULT_TTF_FONT_SIZE
    maxWidth = maxWidth or 1000
    lineHeight = lineHeight or fontSize
    str = str or ""
    return LabelRtf.new(ttf, fontSize, color, maxWidth, lineHeight):text(str):setAnchorPoint(cc.p(0.5, 0.5))
end

--[[震屏动画
@root
@range 幅度 默认10像素
@duration 持续时间 默认1秒
@endpos 最终位置
]]
d.runcShakeAction = function (root, range, duration, endpos)
    if not root then
        return
    end
    range = tonumber(ranger) or 10
    range = math.abs(range)
    duration = tonumber(duration) or 1
    endpos = endpos or cc.p(root:getPositionX(), root:getPositionY())

    root:runAction(cc.Sequence:create(
        cc.Repeat:create(
            cc.Sequence:create(
                cc.CallFunc:create(function ()
                    root:setPosition(cc.p(endpos.x + math.random(-1*range, range), endpos.y + math.random(-1*range, range)))
                end),
                cc.DelayTime:create(1.0/60.0)
            ),
            math.floor(duration*60.0)
        ),
        cc.CallFunc:create(function ()
            root:setPosition(endpos)
        end)
    ))
end

--[[设置精灵纹理
@spt 精灵
@img 图片名]]
d.setTexture = function(spt, img)
    local sptFrm = d.spriteFrameCache:getSpriteFrame(img)
    if spt and type(spt.setSpriteFrame) == "function" and sptFrm then
        spt:setSpriteFrame(sptFrm)
    end
end

--[[
ni = function(aniname, actname, framenum, intertime)
    local index = 0
]]

local function decodeBase64( str64 )
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp={}
    for i=1,64 do
        temp[string.sub(b64chars,i,i)] = i
    end
    temp['=']=0
    local str=""
    for i=1,#str64,4 do
        if i>#str64 then
            break
        end
        local data = 0
        local str_count=0
        for j=0,3 do
            local str1=string.sub(str64,i+j,i+j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1]-1
                str_count = str_count + 1
            end
        end
        for j=16,0,-8 do
            if str_count > 0 then
                str=str..string.char(math.floor(data/math.pow(2,j)))
                data=math.mod(data,math.pow(2,j))
                str_count = str_count - 1
            end
        end
    end

    local last = tonumber(string.byte(str, string.len(str), string.len(str)))
    if last == 0 then
        str = string.sub(str, 1, string.len(str) - 1)
    end
    return str
end
d.decodeBase64 = decodeBase64

d.textureFromBase64 = function(base64str)
    local img = cc.Image:create()
end

--=================================scheduler=================================
--=========================================================================
--全局的延时函数
d.delayCallByTime = function(delaysec, func, ...)
    assert(func ~= nil, "delayCallByTime func is nil")
    local callFunc = func
    local callParms = {...}
    local function _callNextTime()
        local tickEntry
        local function timeUp(time)
            if tickEntry ~= nil then
                d.scheduler:unscheduleScriptEntry(tickEntry)
                tickEntry = nil
                if callParms ~= nil and table.maxn(callParms) > 0 then
                    callFunc(unpack(callParms))
                else
                    callFunc()
                end
            end
        end
        tickEntry = d.scheduler:scheduleScriptFunc(timeUp, delaysec, false)
    end
    _callNextTime()
end
--=================================显示常量=================================
--=========================================================================
--设置默认字体
d.setDefFont = function(fontfile)
    d.DEFAULT_TTF_FONT = fontfile
end

--设置默认的按钮缩放效果
d.setBtnTouchscal = function(btnacsca)
    d.DEFAULT_BTN_PRESS_SCALE = btnacsca
end

--颜色
d.COLOR_WHITE_W = cc.c3b(255,255,255)
d.COLOR_WHITE_B = cc.c3b(0,0,0)
d.COLOR_WIN_MASK = cc.c3b(0,0,0)

return d
