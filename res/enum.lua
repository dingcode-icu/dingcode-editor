enum = {
    -- 创建的节点枚举
    enum_node_type = {
        composites = "composites",
        decorator = "decorator",
        conditionals = "conditionals",
        action = "action",
        const = "const",
        root = "root",
    },
    list_node_type = {"root", "composites", "decorator", "conditionals", "action", "const"},
    logic_node_type = require("nodeconfig"),
    logic_node_list = null,                                         -- 排序过后的列表

    -- 可拖动节点的key类型
    dropnode_key = {
        parent = "parent",                      -- 父节点
        child = "child",                        -- 子节点

        input_int = "input_int",                -- 点击 输入 int
        input_float = "input_float",                -- 点击 输入 float
        input_text = "input_text",                -- 点击 输入 text

        in_int = "in_int",                      -- 输入 int
        out_int = "out_int",                    -- 输出 int
        in_float = "in_float",                      -- 输入 float
        out_float = "out_float",                    -- 输出 float
        in_text = "in_text",                      -- 输入 text
        out_text = "out_text",                    -- 输出 text



        -- 测试功能节点
        input = "input",
        output = "output",
    },
    -- 拖动的一一对应关系
    dropkey_canset = {
        {"parent", "child"},
        {"in_int", "out_int"},
        {"in_float", "out_float"},
        {"in_text", "out_text"},
    },

    -- 事件监听枚举
    evt_keyboard = {
        dev_reload = "dev_reload",                                  -- 刷新当前界面的脚本
        imgui_menu_node = "imgui_menu_node",                        -- 显示右键节点列表
        imgui_menu_input = "imgui_menu_input",                      -- 显示输入
        imgui_menu_start = "imgui_menu_start",                      -- 显示主菜单
        imgui_menu_tree = "imgui_menu_tree",                        -- 显示树形结构列表
        imgui_delete_node = "imgui_delete_node",                    -- 删除节点
        imgui_move_node = "imgui_move_node",                        -- 批量移动节点

        imgui_move_node_to_line = "imgui_move_node_to_line",        -- 移动节点 - 对应移动连线

        sys_exit = "sys_exit",                                      -- 退出程序
        sys_autosave = "sys_autosave",                              -- 自动保存
    },

    -- 节点可拖动的方向
    node_direct = {
        top = "top",
        bottom = "bottom",
        left = "left",
        right = "right",
    },

    -- 节点userdefault 枚举
    userdefault = {
        menu_pathlist = "menu_pathlist",                        -- 之前打开的文件路径列表
    },

    debug_state = {
        none = "1",                                               -- 远程调试的默认状态
        runing = "2",                                             -- 远程调试的运行中状态
        success = "3",                                            -- 远程调试的运行成功状态
        fail = "4",                                               -- 远程调试的运行失败状态
        endrun = "5",
    },
    debug_type = {
        none = "1",
        reset = "2",                                                -- debug 消息类型 - 重置所有状态
        setstate = "3",
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