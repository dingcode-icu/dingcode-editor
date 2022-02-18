local function main()
    require("res/main")
end
function traceback(err)
    print("LUA ERROR: " .. tostring(err))
--    print(debug.traceback())
end
local status, msg = xpcall(main, traceback)
if not status then
    print(msg)
end



