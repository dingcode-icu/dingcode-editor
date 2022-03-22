local FileUtils = {}

-- 获取已经打开过的菜单列表
function FileUtils:getListMenuPath()
    local list = {}
    for i = 1, 5 do
        local str_menu_pathlist = cc.UserDefault:getInstance():getStringForKey(enum.userdefault.menu_pathlist .. "_" .. i)
        if str_menu_pathlist and string.len(str_menu_pathlist) then
            table.insert(list, str_menu_pathlist)
        end
    end
    return list
end
-- 把路径 添加到已经打开过的菜单列表
function FileUtils:addMenuPathToList(path)
    local list = {}
    for i = 1, 5 do
        local str_menu_pathlist = cc.UserDefault:getInstance():getStringForKey(enum.userdefault.menu_pathlist .. "_" .. i)
        if str_menu_pathlist and string.len(str_menu_pathlist) then
            table.insert(list, str_menu_pathlist)
        end
    end
    local path_cur = path
    for i = 1, 5 do
        if path_cur and string.len(path_cur) then
            cc.UserDefault:getInstance():setStringForKey(enum.userdefault.menu_pathlist .. "_" .. i, path_cur)
            if path == list[i] then
                return
            end
            path_cur = list[i]
        end
    end
end

return FileUtils