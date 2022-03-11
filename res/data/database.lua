local dataBase = class("DataBase", {})

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
        parentidlist = {},          -- 父节点
        childidlist = {},         -- 子节点
        input = {},             --
        output = {}

        -- 扩展属性

    }

end
-- TODO 需要去重
function dataBase:generateuuid()
    return ding.guid()
end
function dataBase:getLineIdList(dropKey)
    if not self.data.lineidlist[dropKey] then
        self.data.lineidlist[dropKey] = {}
    end
    return self.data.lineidlist[dropKey]
end
function dataBase:getParentIdList()
    return self:getLineIdList(enum.dropnode_key.parent)
end
function dataBase:getChildIdList()
    return self:getLineIdList(enum.dropnode_key.child)
end
function dataBase:getName()
    return self.data.config.name or ""
end

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