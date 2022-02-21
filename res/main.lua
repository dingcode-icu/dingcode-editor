-- local lua_ex = require("ding")
-- local config = require("config")

require("path")
--require("imguix") //imgui


---入口
local function main()
    local sc = cc.Scene.create()
    cc.Director:getInstance():runWithScene(sc)
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






