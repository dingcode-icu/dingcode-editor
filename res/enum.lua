enum = {
    -- 创建的节点枚举
    enum_node_type = {
        composites = "composites",
        decorator = "decorator",
        conditinals = "conditinals",
        action = "action",
    },
    logic_node_type = require("nodeconfig"),
    logic_node_list = null,                                         -- 排序过后的列表

    -- 可拖动节点的key类型
    dropnode_key = {
        parent = "parent",
        child = "child",
        input = "input",
        output = "output",
    },

    -- 事件监听枚举
    evt_keyboard = {
        dev_reload = "dev_reload",                                  -- 刷新当前界面的脚本
        imgui_menu_node = "imgui_menu_node",                        -- 显示右键节点列表
        imgui_delete_node = "imgui_delete_node",                    -- 删除节点
        imgui_move_node = "imgui_move_node",                        -- 批量移动节点

        imgui_move_node_to_line = "imgui_move_node_to_line",        -- 移动节点 - 对应移动连线
    },

    -- 节点可拖动的方向
    node_direct = {
        top = "top",
        bottom = "bottom",
        left = "left",
        right = "right",
    },
}

local logic_node_list = {}
enum.logic_node_list = logic_node_list
for i, v in pairs(enum.logic_node_type) do
    logic_node_list[i] = {}
    for name, data in pairs(v) do
        table.insert(logic_node_list[i], name)
    end
    table.sort(logic_node_list[i])
end


return enum