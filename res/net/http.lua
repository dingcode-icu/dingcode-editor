local http = {}
--[[
http dylib by rust

github:
https://github.com/dwbmio/r_extern

target:
i686-pc-windows-msvc
]]
local ffi = require("ffi")
local c = ffi.cdef [[
   //test
   int add(int a);
   //http
   void http_set_host(const char* b);
   void http_set_timeout(int a);
   const char* http_get(const char* b);
   const char* http_post(const char* b, const char* d);
]]


local json = require("lib/json")
local c= ffi.load("res/net/r_extern")

local function http_log(...)
    print(string.format("[http] %s", table.concat({...}, " | ")))
end

function http:init()
    http_log("init http")
    c.http_set_host("http://static.bbclient.icu:8083")
    c.http_set_timeout(5)
end

function http:get(path, suc_cb)
    local ret = c.http_get(path)
    local l_str = string.split(ffi.string(ret), "|")
    if #l_str > 1 and l_str[1] == "true" then
        suc_cb(l_str[2])
    else
        http_log("[lua-http]http get <%s>failed! resp->\n<%s>",path, l_str[1])
    end
end

function http:post(path, dic_data, suc_cb)
    local ret = c.http_post(path, json.encode(dic_data))
    local l_str = string.split(ffi.string(ret), "|")
    if #l_str > 1 and l_str[1] == "true" then
        suc_cb(l_str[2])
    else
        http_log("http get <%s>failed! resp->\n<%s>",path, l_str[1])
    end
end
return http