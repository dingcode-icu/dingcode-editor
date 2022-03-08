local Event = require("res/lib/event")

--语言配置
local Lang = require("res/lib/language/Lang")
Lang:init({
    language="zh_cn"
})

-- 全部菜单
--上方主菜单
local menu_mainbar = require("res/imguix/menu/menu_mainbar")
menu_mainbar:show()

--右键节点主菜单
local menu_node = require("res/imguix/menu/menu_node")
menu_node:hide()
Event:addEventListener(enum.evt_keyboard.imgui_menu_node, function(event)
    if event and event.isHide then
        menu_node:hide()
    else
        menu_node:show(event)
    end

end)






