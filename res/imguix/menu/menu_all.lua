
--语言配置
local Lang = require("res/lib/language/Lang")
Lang:init({
    language="zh_cn"
})

-- 全部菜单
--上方主菜单
local a = require("res/imguix/menu/menu_mainbar")
a:show()

--右键节点主菜单
local a = require("res/imguix/menu/menu_node")
a:show()