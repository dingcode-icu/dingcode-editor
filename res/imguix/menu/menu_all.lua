local Event = require("lib/event")

--语言配置
local Lang = require("lib/language/Lang")
Lang:init({
    language="zh_cn"
})

-- 全部菜单
--上方主菜单
local menu_mainbar = require("imguix/menu/menu_mainbar")
menu_mainbar:show()

--右键节点主菜单
local menu_node = require("imguix/menu/menu_node")
menu_node:hide()
Event:addEventListener(enum.evt_keyboard.imgui_menu_node, function(event)
    if event and event.isHide then
        menu_node:hide()
    else
        menu_node:show(event)
    end

end)

-- 输入菜单
local menu_input = require("imguix/menu/menu_input")
menu_input:hide()






