enum = {
    -- 创建的节点枚举
    logic_node_type = {
        composites = "composites",                              -- "新建组合节点",
        sequence = "sequence",                                  -- "顺序条件",
        selector = "selector",                                  -- "选择条件",
        parallel = "parallel",                                  -- "平行条件",
        decorator = "decorator",                                -- "新建修饰节点",
        conditinals = "conditinals",                            -- "新建条件节点",

        action = "action",                                      -- "新建行为节点",
        action_node = "action_node",                            -- node
        action_node_active = "action_node_active",
        action_node_pos = "action_node_pos",
        action_node_scale = "action_node_scale",
        action_node_anchor = "action_node_anchor",
        action_node_size = "action_node_size",
        action_node_color = "action_node_color",
        action_node_alpha = "action_node_alpha",
        action_sprite = "action_sprite",                        -- 图片
        action_sprite_path = "action_sprite_path",
        action_lab = "action_lab",                              -- lab
        action_lab_string = "action_lab_string",
        action_lab_fontsize = "action_lab_fontsize",
        action_richtext = "action_richtext",                    -- 富文本
        action_richtext_string = "action_richtext_string",
        action_richtext_fontsize = "action_richtext_fontsize",
        action_spine = "action_spine",                          -- spine
        action_spine_animation = "action_spine_animation",
        action_spine_loop = "action_spine_loop",
        action_spine_timescale = "action_spine_timescale",



    },

    -- 事件监听枚举
    evt_keyboard = {
        dev_reload = "dev_reload",                                  -- 刷新当前界面的脚本
        imgui_menu_node = "imgui_menu_node",                        -- 显示右键节点列表
        imgui_delete_node = "imgui_delete_node",                    -- 删除节点
        imgui_move_node = "imgui_move_node",                        -- 批量移动节点
    }
}

return enum