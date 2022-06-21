---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 2022/6/9 2:34 下午
---
local http = {}

function http:init()
    print("init http")
    self._host = "http://static.bbclient.icu:8083{path}"
end

function http:_fetch(method_str, path, str_data, suc_cb)
    local METHOD_MAP = {
        get = cc.HttpRequestType.GET,
        post = cc.HttpRequestType.POST
    }
    local request = cc.HttpRequest();
    request:setUrl(string.gsub(self._host, "{path}", path))
    request:setRequestType(METHOD_MAP[method_str] or cc.HttpRequestType.GET)
    if str_data then
        request:setUserData(str_data)
    end
    request:setResponseCallback(function(sender, resp)
        -- 保留request的引用 避免在回调回来之前 释放掉
        request = nil
        local ret = resp:getResponseData()
        if not resp:isSucceed() then
            print("http error ")
            ding.showToast(string.format("http error:code=%s, msg=%s", request:getResponseCode(), ret))
            return
        end
        print("http get suc from url ==============")
        print(url)
        print(ret)
        if suc_cb then
            suc_cb(ret)
        end
    end)
    cc.HttpClient:getInstance():send(request)
end

function http:get(path, suc_cb)
    self:_fetch("get", path,nil, suc_cb)
end

function http:post(path, std_data, suc_cb)
    self:_fetch("post",  path, std_data, suc_cb)
end
return http