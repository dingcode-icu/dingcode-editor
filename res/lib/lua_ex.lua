--==================================
-- 在funcitons.lua中已经扩展过 这里
-- 是额外的
--==================================
require("lib/functions")

--[[同functins.lua 中的handler]]
--[[不同：参数通过了clone不篡改原参数；命名安全点]]
function c_func(obj, method, ...)
    local param = {...}
    return function(...)
        local tmp = clone(param)
        table.insertto(tmp , {...})
        if not tmp then
            return method(obj)
        else
            return method(obj, unpack(tmp))
        end
    end
end


--[[对象钩子函数执行]]
function func_hook(obj, funcname, ...)
    if type(obj[funcname]) == "function" then
        return obj[funcname](obj, ...)
    elseif type(obj["class"]) == "table" then
        if type(obj["class"][funcname]) == "function" then
            return obj["class"][funcname](obj, ...)
        end
    end
end


--[[empty 是不是空的字符串 , 数字是0 ，空的table]]
function empty(value)
    if value == '' or value == 0 or value == {} or value == nil then return true end
end

--[[table方法扩展:连接多个数组
@param list 首个字符串
@param ... 数组或者数据
@return table 连接后的数组
]]
function table.connect(list, ...)
    if list and type(list) ~= "table" then
        list = {list}
    end

    for _,v in ipairs({...}) do
        if type(v) == "table" then
            for _,vv in ipairs(v) do
                table.insert(list, vv)
            end
        else
            table.insert(list, v)
        end
    end
    return list
end

--[[table扩展:判断表是否为空
@tbl
@return boolean
]]
function table.isNil(tbl)
    if type(tbl) == "table" then
        return not next(tbl)
    else
        return true
    end
end

--[[table扩展:取得table中的某一个key下的值
@tbl
@... key列表
@return obj, boolean 查找的值, 是否找到
]]
function table.find(tbl, ...)
    if type(tbl) ~= "table" then
        return nil
    end

    local obj = tbl
    for _, keys in ipairs( {...} ) do
        if type(keys) == "string" then
            for _, key in ipairs( totable(string.split(keys,".")) ) do
                if type(obj) == "table" and obj[key] ~= nil then
                    obj = obj[key]
                else
                    return nil
                end
            end
        else
            if type(obj) == "table" and obj[keys] ~= nil then
                obj = obj[keys]
            else
                return nil
            end
        end
    end

    return obj
end

--[[table扩展:排序
@tbl
@key 排序的key nil表示使用value本身排序
@isgradown 是否降序, 默认false
]]
--这里是私有的排序方法
local function _get_sortfunc(key, isgradown)
    isgradown = not not isgradown
    if key then
        local _sort = function (x, y)
            local a = table.find(x, unpack(string.split(key, ".")))
            local b = table.find(y, unpack(string.split(key, ".")))
            return isgradown and tonum(a) > tonum(b) or tonum(a) < tonum(b)
        end
        return _sort

    else
        local _sort = function (x, y)
            return isgradown and tonum(x) > tonum(y) or tonum(x) < tonum(y)
        end
        return _sort
    end
end
function table.sortbykey(tbl, key, isgradown)
    table.sort(tbl, _get_sortfunc(key, isgradown))
end

function tonum(v, base)
    return tonumber(v, base) or 0
end

function toint(v)
    return math.round(tonum(v))
end

function tobool(v)
    return (v ~= nil and v ~= false)
end

function totable(v)
    if type(v) ~= "table" then v = {} end
    return v
end

function catch(blocktb)
    return {catch = blocktb[1]}
end

function try(blocktb)
    -- get the try function
    local tryfunc = blocktb[1]
    assert(tryfunc)

    -- get catch and finally functions
    local catchfunc = blocktb[2]
    if catchfunc and blocktb[3] then
        table.join2(catchfunc, blocktb[2])
    end

    -- try to call it
    local ok, errors = pcall(tryfunc)
    if not ok then
        -- run the catch function
        if catchfunc and catchfunc.catch then
            catchfunc.catch(errors)
        end
    end

    -- run the finally function
    if catchfunc and catchfunc.finally then
        catchfunc.finally(ok, errors)
    end

    -- ok?
    if ok then
        return errors
    end
end