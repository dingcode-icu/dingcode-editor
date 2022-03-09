require("path")
require("lib/lua_ex")
require("lib/display")



---入口
local function main()
    local sc = cc.Scene.create()
    cc.Director:getInstance():runWithScene(sc)

    --local bg = d.sp("texture/grid.png")
    require("res/render/memory")
    require("res/enum")
    require("res/release")
    require("res/imguix/init"):init()
    require("res/render/init"):init()
    require("res/imguix/menu/menu_all")
end

---打印报错及堆栈
local function traceback(err)
    print("LUA ERROR: " .. tostring(err))
    print(debug.traceback())
end

local status, msg = xpcall(main, traceback)
if not status then
    print(msg)
end






