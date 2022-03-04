enum = {
    -- 创建的节点枚举
    nodetype = {
        composites = 1,         -- "新建组合节点",
        sequence = 1001,        -- "顺序条件",
        selector = 1002,        -- "选择条件",
        parallel = 1003,        -- "平行条件",
        decorator = 2,          -- "新建修饰节点",
        conditinals = 3,        -- "新建条件节点",
        action = 4,             -- "新建行为节点",
    },

    -- 事件监听枚举
    eventconst = {
        imgui_menu_node = "imgui_menu_node",                        -- 显示右键节点列表
        imgui_delete_node = "imgui_delete_node",                    -- 删除节点
        imgui_move_node = "imgui_move_node",                        -- 批量移动节点
    }
}

return enum