local dataBase = class("DataBase", {})
local json = require("lib/json")

function dataBase:ctor(config)

    if not config then
        return
    end
    self.data = {
        uuid = self:generateuuid(),

        -- 配置信息
        config = config,

        -- 可设置的属性{id, key}
        lineidlist = {
            [enum.dropnode_key.parent] = {},                -- 父节点
            [enum.dropnode_key.child] = {},                 -- 子节点
        },
        input = {},             --   输入值 (数组) input = {int_1 = {1}}
        output = {}

        -- 扩展属性

    }

end
-- TODO 需要去重
function dataBase:generateuuid()
    return ding.guid()
end
-- 是否可以导出
function dataBase:isCanExport(key)
    if key == enum.dropnode_key.parent then
        if self:gettype() ~= enum.enum_node_type.root then
            -- 除了root 节点 都应该有父节点
            local list = self:getLineIdList(key)
            if list and #list <= 0 then
                return false
            end
        end
    end
    return true
end
-- 是否已经包含某个id的节点
function dataBase:isContainForLineList(dropKey, targetId, targetKey)
    local list = self:getLineIdList(dropKey)
    if list then
        for i, v in pairs(list) do
            if v.id == targetId and v.key == targetKey then
                return true
            end
        end
    end
    return false
end
-- 添加拖动节点数据
function dataBase:addDataToLineList(dropKey, targetId, targetKey)
    local list = self:getLineIdList(dropKey)
    if list then
        table.insert(list, {id = targetId, key = targetKey})
    end
end
function dataBase:deleteDataFromLineList(dropKey, targetId, targetKey)
    local list = self:getLineIdList(dropKey)
    if list then
        for i, v in ipairs(list) do
            if v.id == targetId and v.key == targetKey then
                table.remove(list, i)
                return
            end
        end

    end
end
-- 获取已经包含的节点列表
function dataBase:getLineIdList(dropKey)
    if not self.data.lineidlist[dropKey] then
        self.data.lineidlist[dropKey] = {}
    end
    return self.data.lineidlist[dropKey]
end
-- 获取已经包含的父节点列表
function dataBase:getParentIdList()
    return self:getLineIdList(enum.dropnode_key.parent)
end
-- 获取已经包含的子节点列表
function dataBase:getChildIdList()
    return self:getLineIdList(enum.dropnode_key.child)
end
-- 设置输入的列表配置
function dataBase:setListInputForId(id, list)
    self.data.input[id] = list
end
-- 设置输出的列表配置
function dataBase:setListOutputForId(id, list)
    self.data.output[id] = list
end
-- 获取输入的列表配置
function dataBase:getListInputForId(id)
    if not self.data.input[id] then
        self.data.input[id] = {}
    end
    return self.data.input[id]
end
-- 获取输出的列表配置
function dataBase:getListOutputForId(id)
    if not self.data.output[id] then
        self.data.output[id] = {}
    end
    return self.data.output[id]
end
-- 获取名字
function dataBase:getName()
    return self.data.config.name or ""
end
-- 获取描述
function dataBase:getDesc()
    return self.data.config.desc or ""
end
-- 获取输入的列表配置
function dataBase:getListInputConfig()
    if type(self.data.config.input) == "string" then
        self.data.config.input = json.decode(self.data.config.input)
    end
    return self.data.config.input or {}
end
-- 获取输出的列表配置
function dataBase:getListOutputConfig()
    if type(self.data.config.output) == "string" then
        self.data.config.output = json.decode(self.data.config.output)
    end
    return self.data.config.output or {}
end
function dataBase:getConfigForKey(key)
    for i, v in pairs(self:getListInputConfig()) do
        if i == key then
            return v
        end
    end
    for i, v in pairs(self:getListOutputConfig()) do
        if i == key then
            return v
        end
    end
    return nil
end
-- 直接设置数据 （导入时候用）
function dataBase:setData(data)
    if data then
        -- 覆盖配置文件
        if data.config.name and data.config.type then
            if enum.logic_node_type[data.config.type] and enum.logic_node_type[data.config.type][data.config.name] then
                data.config = enum.logic_node_type[data.config.type][data.config.name]
            end
        end
        self.data = data
    end
end
-- 获取数据
function dataBase:getData()
    return self.data
end

function dataBase:getuuid()
    if self and self.data and self.data.uuid then
        return self.data.uuid
    end
    return null
end
function dataBase:gettype()
    if self and self.data and self.data.config and self.data.config.type then
        return self.data.config.type
    end
    return null
end




return dataBase