local nodeConfig = {
    composites = {
        sequence = {
            name = "sequence",
            type = "composites",
            desc = "描述",
            supposeType = "common",
        },
        selector = {
            name = "selector",
            type = "composites",
            desc = "描述",
            supposeType = "common",
        },
        parallel = {
            name = "parallel",
            type = "composites",
            desc = "描述",
            supposeType = "common",
        },
        decorator = {
            name = "decorator",
            type = "composites",
            desc = "描述",
            supposeType = "common",
        },
    },
    decorator = {

    },
    conditinals = {

    },
    action = {

    }
}
local function requireConfig(path)
    local data = require(path)
    if data and data.type then
        if not nodeConfig[data.type] then
            nodeConfig[data.type] = {}
        end
        nodeConfig[data.type][data.name] = data
    else
        error("error from load nodeconfig")
    end
end
local list = require("engine/cocos/config/allnodeconfig")
for i, v in pairs(list) do
    requireConfig(v)
end

return nodeConfig