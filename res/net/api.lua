local Api = {}
local json = require("lib/json")
local enum = enum
local http = require("net/http")

-- 初始化配置
function Api:initConfig()
    print("===========================")
    http:get("/api/dingcode/dnode", function(resp)
        local data = json.decode(resp)
        if data then

            if data.code ~= 0 or not data.data then
                print("http initConfig error")
                print(data.msg)
                return
            end

            local logic_node_type = {}
            enum.logic_node_type = logic_node_type
            local logic_node_list = {}
            enum.logic_node_list = logic_node_list

            for i, v in ipairs(data.data) do
                if v.graph_type then
                    if not logic_node_type[v.graph_type] then
                        logic_node_type[v.graph_type] = {}
                    end
                    v.type = v.graph_type
                    v.desc = v.descrip
                    v.supposeType = v.suppose_type

                    logic_node_type[v.graph_type][v.name] = v

                    if enum.show_suppose_type and v.supposeType ~= nil and enum.show_suppose_type[v.supposeType] == nil then
                        enum.show_suppose_type[v.supposeType] = true
                    end

                end
            end

            local logic_node_list = {}
            enum.logic_node_list = logic_node_list
            for i, v in pairs(enum.logic_node_type) do
                logic_node_list[i] = {}
                for name, _ in pairs(v) do
                    table.insert(logic_node_list[i], name)
                end
                table.sort(logic_node_list[i])
            end

        end

    end)
end

-- 添加节点
function Api:addNode(data, suc_cb)
    local data = {
        name = data.name,
        descrip = data.desc,
        suppose_type = data.sType,
        graph_type = data.gType,
        input = data.input or {},
        output = data.output or {}
    }
    dump(data, '-->>>addnode')
    http:post("/api/dingcode/add", data, suc_cb)
end

return Api
