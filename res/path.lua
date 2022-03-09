local fu = cc.FileUtils:getInstance()
local root = fu:getDefaultResourceRootPath()

local dic = fu:getSearchPaths()
table.insert(dic, 1,"D:/public_work/dingcode_editor/res")
for i  , v in pairs(dic) do
    print(i, v, '-->>iivvv')
    end
fu:setSearchPaths(dic)

print("root search path is ->", root)