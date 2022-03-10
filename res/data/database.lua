local dataBase = class("DataBase", {})

function dataBase:ctor(config)

    if not config then
        return
    end
    self.data = {
        uuid = self:generateuuid(),
        config = config,

        -- 配置信息


        -- 可设置的属性


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