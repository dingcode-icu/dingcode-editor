local node_config = {
    root = {
        entry = {
            name = "entry",
            type =  "root",
            desc = "绑定单个渲染对象入口",
            supposeType = "common",
            input = {
                path = {
                    direct = "left",
                    key = "input_text",
                    numMax = 0,
                    desc = "输入名字",
                },
            },
            output = {},
        },
        self_ = {
            name = "self",
            type =  "root",
            desc = "组建的绑定最想作为节点",
            supposeType = "common",
            input = {},
            output = {},
        },
        
    },
    composites = {
        sequence = {
            name = "sequence",
            type = "composites",
            desc = "顺序",
            supposeType = "common",
        },
        selector = {
            name = "selector",
            type = "composites",
            desc = "选择",
            supposeType = "common",
        },
        parallel = {
            name = "parallel",
            type = "composites",
            desc = "并行",
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
                    desc = "输入小数",
                },
            },
            output = {
                out_float_1 = {
                    direct = "right",
                    key = "out_float",
                    numMax = 1,
                    desc = "输出",
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
                    desc = "输入整数",
                },
            },
            output = {
                out_int_1 = {
                    direct = "right",
                    key = "out_int",
                    numMax = 1,
                    desc = "输出",
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
                    desc = "输入文本",
                },
            },
            output = {
                out_text_1 = {
                    direct = "right",
                    key = "out_text",
                    numMax = 1,
                    desc = "输出",
                },
            },
        },
        child_node = {
            name = "child_node",
            type = "const",
            desc ="根据path获取子节点",
            supposeType ="common",
            input = {
                child_path = {
                    direct = "left",
                    key = "child_path",
                    numMax = 1
                }
            }
        }
    },
    decorator = {
        loop = {
            name = "loop", 
            type = "decorator", 
            desc = "重复执行",
            supposeType = "common",
            input = {
                cnt = {
                    direct = "left",
                    key = "input_int",
                    numMax = 0,
                    desc = "循环次数(-1为无限循环)",
                },
            },
        },
        inverter = {
            name = "inverter", 
            type = "decorator", 
            desc = "取反",
            supposeType = "common"
        },
        return_failure = {
            name = "return failure",
            type = "decorator", 
            desc = "一直返回失败", 
            supposeType = "common"
        },
        return_success = {
            name = "return_success", 
            type = "decorator", 
            desc = "一直返回成功", 
            supposeType = "common"
        },
        util_failure = {
            name = "until failure",
            type = "decorator", 
            desc = "一直执行直到返回失败", 
            supposeType = "common"
        },
        util_success = {
            name = "until success",
            type = "decorator", 
            desc = "一直执行直到返回成功", 
            supposeType = "common"
        }
        
    },
    action = {
        log = {
            name = "log",
            type = "action",
            desc = "打印一个log",
            supposeType = "common",
            input = {
                log = {
                    direct = "left",
                    key = "input_string",
                    numMax = 0,
                    desc = "要输出的日志",
                },
            },
        },
        wait = {
            name = "wait",
            type = "action",
            desc = "等待一段时间",
            input = {
                dt = {
                    direct = "left",
                    key = "input_float",
                    numMax = 0,
                    desc = "要等待的时间",
                },
            },
        },
        send_event = {
            name = "send event",
            type = "action",
            desc = "发送一个事件",
            input = {
                event = {
                    direct = "left",
                    key = "input_string",
                    numMax = 0,
                    desc = "要发送的事件名",
                },
            },
        }
    },
    --proj 
    demo_traffic = {}
}
local function requireConfig(path)
    local data = require(path)
    local function add_node(data_)
        if not node_config[data_.type] then
            node_config[data_.type] = {}
        end
        node_config[data_.type][data_.name] = data_
    end
    if type(data) ~= "table" then return end
    --single
    if data.type then
        dump(data, "--->>single")
        add_node(data)
    end
    --list
    for _, c in ipairs(data) do
        add_node(c)
    end
end
local list = require("engine/cocos/all_config")
for i, v in pairs(list) do
    requireConfig(v)
end

return node_config