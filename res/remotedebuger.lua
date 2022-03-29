local DataManager = require("data/datamanager")
local ViewManager = require("render/viewmanager")

local remotedebuger = {}

function remotedebuger:init()
    ding.setOnRecviedCallback(function(strRecvied)
        if strRecvied then
            local list = string.split(strRecvied, "|")
            if list[1] and list[2] then
                
            end
        end
    end)
end

return remotedebuger