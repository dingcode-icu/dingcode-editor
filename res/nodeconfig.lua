local nodeConfig = {
    root = {
        root_str = {
            name = "root_str",
            type = "root",
            desc = "根节点",
            supposeType = "common",
            input = {
                input_text_1 = {
                    direct = "left",
                    key = "input_text",
                    numMax = 0,
                },
            },
            output = {},
        },
    },
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
        }
    },
    const = {
        float = {
            name = "float",
            type = "const",
            desc = "小数",
            supposeType = "common",
            input = {
                input_float_1 = {
                    direct = "left",
                    key = "input_float",
                    numMax = 0,
                },
            },
            output = {
                out_float_1 = {
                    direct = "right",
                    key = "out_float",
                    numMax = 1,
                },
            },
        },
        int = {
            name = "int",
            type = "const",
            desc = "整数",
            supposeType = "common",
            input = {
                input_int_1 = {
                    direct = "left",
                    key = "input_int",
                    numMax = 0,
                },
            },
            output = {
                out_int_1 = {
                    direct = "right",
                    key = "out_int",
                    numMax = 1,
                },
            },
        },
        text = {
            name = "text",
            type = "const",
            desc = "文本",
            supposeType = "common",
            input = {
                input_text_1 = {
                    direct = "left",
                    key = "input_text",
                    numMax = 0,
                },
            },
            output = {
                out_text_1 = {
                    direct = "right",
                    key = "out_text",
                    numMax = 1,
                },
            },
        },
    },
    decorator = {
        --decorator = {
        --    name = "decorator",
        --    type = "composites",
        --    desc = "描述",
        --    supposeType = "common",
        --},
    },
    conditionals = {},
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