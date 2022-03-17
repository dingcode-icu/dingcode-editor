--- 自定义的shader的缓存管理
--@classmod ShaderMgr
local ShaderMgr = class("ShaderMgr")
--==================================
--===========================================================================

---管理类初始化
-- @return nil 
-- @usage 构造函数完成后
function ShaderMgr:init(shaderres)
    self._bindcache = {}
    self:__init_customeeff(shaderres)
end

--[[--
    销毁所有的shader缓存 
    @return nil 
    @usage （暂时还没有地方销毁，讲道理应该是游戏结束，不管了）
    ]]
function ShaderMgr:destory()
    for _, glprogram in ipairs(self._bindcache) do 
        
    end
end

--[[--
    获取自定义的shader  
    @tparam string effname shader的名字
    @return userdata shader
    @usage 当想使表现的精灵|图像等变成使用自定义的shader进行表现的时候
            local sp = d.sp("xx.png")
            local cusshader =
            sp:setGLProgramState(state)
    ]]
function ShaderMgr:getEffect(effname)
    local custom_state = self._bindcache[effname]
    if (custom_state) then 
        return  custom_state
    else 
        print("No eff named<%s>", effname)
    end
end

--[[hader的初始化创建 
    会在管理类初始化的时候自动调用
    ]]
function ShaderMgr:__init_customeeff(shaderres)
    self:_crt_noparmsShader(shaderres)
end


--创建无参数的shader
function ShaderMgr:_crt_noparmsShader(shaderres)
    local s_program
    local s_state
    for eff_name, res in pairs(shaderres) do
        s_program = cc.GLProgram.createWithFilenames(res[1], res[2])
        if not s_program then
            break
        end

        s_state = cc.GLProgramState.getOrCreateWithGLProgram(s_program)
        if res[3] and s_state then
            self:_init_uniform(s_state, res[3])
        end
        self._bindcache[eff_name] = s_state
    end
end


function ShaderMgr:_init_uniform(p, tb)
    for key, val in pairs(tb) do
        if type(val) == "table" then
            p:setUniformVec3(key, cc.vec3(val.x, val.y, val.z))
        elseif type(val) == "number" then
            p:setUniformFloat(key, val)
        end
    end
end

local _inc = {
    clsinc = nil 
}

function _inc:getInc()
    if self.clsinc == nil then 
        self.clsinc = ShaderMgr:create()
    end
    return self.clsinc
end

return _inc