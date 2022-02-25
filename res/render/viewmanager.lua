local DataManager = require("res/data/datamanager")

local viewManager = {
    view = {
        viewList = {},                      -- 创建的数据
    },
    isInit = false,                         -- 是否已经初始化
}

function viewManager:init(config)
    if config then
        if config.dataList then

        end
    end

    self.isInit = true
end

function viewManager:createNode(dataNode)
    print("创建node， type = ", dataNode:gettype())
end

return viewManager