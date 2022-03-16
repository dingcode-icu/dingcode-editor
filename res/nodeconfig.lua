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
    const = {
        float = {
            name = "float",
            type = "const",
            desc = "小数",
            supposeType = "common",
            input = {
                {
                    direct = "left",
                    key = "input_float",
                    numMax = 0,
                },
            },
            output = {},
        },
        int = {
            name = "int",
            type = "const",
            desc = "整数",
            supposeType = "common",
            input = {
                {
                    direct = "left",
                    key = "input_int",
                    numMax = 0,
                },
            },
            output = {},
        },
        text = {
            name = "text",
            type = "const",
            desc = "文本",
            supposeType = "common",
            input = {
                {
                    direct = "left",
                    key = "input_text",
                    numMax = 0,
                },
            },
            output = {},
        },
    },
    decorator = {},
    conditinals = {},
    action = {},
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