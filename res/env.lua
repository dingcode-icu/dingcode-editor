local m = {}

function m.init()
    -- search path
    local fu = cc.FileUtils:getInstance()
    local root = fu:getDefaultResourceRootPath()

    -- for windows debug 
    local dic = fu:getSearchPaths()
    table.insert(dic, 1, "D:/public_work/dingcode_editor/res")
    fu:setSearchPaths(dic)
    print("root search path is ->", root)
    return m
end

m.WHITE_KEYS = {"Lang", "ImGuiRenderer", "ImGuiDraw"}

function m.limit_global()
    -- limit _G kes 
    local lm = {
        __newindex = function(t, k, v)
            print("k's count is", table.find(m.WHITE_KEYS, k), k)
            if table.find(m.WHITE_KEYS, k) then
                t[k] = v
                return
            end
            print(string.format("[LUAENV ERROR]_G could not set new key=<%s> val=<%s>", k, v))
            return
        end
    }
    setmetatable(_G, lm)
    return m
end

return m
