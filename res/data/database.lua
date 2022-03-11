local dataBase = class("DataBase", {})

function dataBase:ctor(config)

    if not config then
        return
    end
    self.data = {
        uuid = self:generateuuid(),

        -- 配置信息
        config = config,

        -- 可设置的属性
        parent = null,          -- 父节点
        childlist = {},         -- 子节点
        input = {},             --
        output = {}

        -- 扩展属性

    }

end
-- TODO 需要去重
function dataBase:generateuuid()
    return ding.guid()
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