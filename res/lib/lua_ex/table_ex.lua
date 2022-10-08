function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.keys(hashtable)
    local keys = {}
    for k, v in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(hashtable)
    local values = {}
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function table.insertto(dest, src, begin)
    begin = checkint(begin)
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then
            return i
        end
    end
    return false
end

function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then
            return k
        end
    end
    return nil
end

function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then
                break
            end
        end
        i = i + 1
    end
    return c
end

function table.map(t, fn)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

function table.walk(t, fn)
    for k, v in pairs(t) do
        fn(v, k)
    end
end

function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then
            t[k] = nil
        end
    end
end

function table.unique(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end

function table.clone(object)
    local lookup_table = {}
    local function copyObj(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[copyObj(key)] = copyObj(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return copyObj(object)
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

    for _, v in ipairs({...}) do
        if type(v) == "table" then
            for _, vv in ipairs(v) do
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
    for _, keys in ipairs({...}) do
        if type(keys) == "string" then
            for _, key in ipairs(totable(string.split(keys, "."))) do
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
-- 这里是私有的排序方法
local function _get_sortfunc(key, isgradown)
    isgradown = not not isgradown
    if key then
        local _sort = function(x, y)
            local a = table.find(x, unpack(string.split(key, ".")))
            local b = table.find(y, unpack(string.split(key, ".")))
            return isgradown and tonum(a) > tonum(b) or tonum(a) < tonum(b)
        end
        return _sort

    else
        local _sort = function(x, y)
            return isgradown and tonum(x) > tonum(y) or tonum(x) < tonum(y)
        end
        return _sort
    end
end
function table.sortbykey(tbl, key, isgradown)
    table.sort(tbl, _get_sortfunc(key, isgradown))
end
