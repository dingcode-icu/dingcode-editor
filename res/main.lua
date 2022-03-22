---入口
local function main()
    require("path")
    require("lib")
    require("enum")
    require("release")
    require("imguix/init"):init()
    require("render/init")
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






