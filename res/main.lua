---[TEST]
local function TEST_()
    -- debug
    -- async node-config to remote service
    if _G.RELEASE.ASYNC_TO_REMOTE then
        local json = require("lib.json")
        local strData = json.encode(enum.logic_node_type)
        local src = io.writefile("all_node.json", strData)
    end
end

---入口
local function main()
    -- global
    local env = require("env").init()
    require("lib")
    require("enum")

    require("release")
    env.limit_global()
    -- ui logic
    require("imguix/init"):init()
    require("render/init")
    require("net/http"):init()

    -- TEST_()
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

