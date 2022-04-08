local DataManager = require("data/datamanager")
local ViewManager = require("render/viewmanager")

local remove_debugger = {}

function remove_debugger:init()
    ding.setOnRecviedCallback(function(strRecvied)
        print("recvied message: ", strRecvied)
        if strRecvied then
            local typelist = string.split(strRecvied, "$")
            if typelist[1]then
                -- 消息的类型
                local type = typelist[1]
                local strRule = typelist[2]
                if type == enum.debug_type.reset then
                    ViewManager:resetAllDebugState()
                elseif type == enum.debug_type.setstate then
                    if strRule then
                        local list = string.split(strRule, "|")
                        if list[1] and list[2] then
                            local id = list[1]
                            local state = list[2]
                            local viewData = ViewManager:getNodeViewForId(id)
                            if viewData then
                                viewData:setDebugState(state)
                            else
                                print("setOnRecviedCallback error, id = ", id)
                            end
                        end
                    end
                end
            end

        end
    end)
end

return remove_debugger