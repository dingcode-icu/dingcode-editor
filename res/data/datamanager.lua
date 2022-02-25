local DataBase = require("res/data/database")

local dataManager = {
    data = {
        dataList = {},                      -- 创建的数据
    },
    isInit = false,                         -- 是否已经初始化
}

function dataManager:init(config)
    print("datamanager init")
    dump(config)
    if config then
        if config.dataList then
            for i, v in pairs(config.dataList) do
                local data = DataBase.new()
                data:setData(v)
                self.data.dataList[data:getuuid()] = data
            end
        end
    end

    self.isInit = true

    local ViewManager = require("res/render/viewmanager")
    ViewManager:init(config)
end

function dataManager:get_alldata()
    local real = {
        dataList={}
    }
    for i, v in pairs(self.data.dataList) do
        real.dataList[i] = v:getData()
    end
    return real
end

function dataManager:createData(nodeType)

    local data = DataBase.new(nodeType)

    self.data.dataList[data:getuuid()] = data

    return data
end

function dataManager:removeData(id)
    if id then
        self.data.dataList.delete(id)
    end
end

return dataManager