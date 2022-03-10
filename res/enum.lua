enum = {
    -- 创建的节点枚举
    logic_node_type = require("nodeconfig"),

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

return enum