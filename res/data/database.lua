local uuid = require 'lib/uuid'
local dataBase = class("DataBase", {})

function dataBase:ctor(type)
    if not type then
        return
    end
    self.data = {
        type = type,
        uuid = uuid.generate()

        -- 配置信息


        -- 可设置的属性


        -- 扩展属性


    }




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
    if self and self.data and self.data.type then
        return self.data.type
    end
    return null
end




return dataBase