--[[同functins.lua 中的handler]]
--[[不同：参数通过了clone不篡改原参数；命名安全点]]
function c_func(obj, method, ...)
    local param = {...}
    return function(...)
        local tmp = clone(param)
        table.insertto(tmp, {...})
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
    if value == '' or value == 0 or value == {} or value == nil then
        return true
    end
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
    if type(v) ~= "table" then
        v = {}
    end
    return v
end

function catch(blocktb)
    return {
        catch = blocktb[1]
    }
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

-- 保留N位小数
function GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end

    n = n or 0;
    n = math.floor(n)
    local fmt = '%.' .. n .. 'f'
    local nRet = tonumber(string.format(fmt, nNum))

    return nRet;
end
