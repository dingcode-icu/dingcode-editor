local Event = require("lib/event")

--语言配置
local Lang = require("lib/language/Lang")
Lang:init({
    language="zh_cn"
})

-- 全部菜单
--上方主菜单
local menu_mainbar = require("imguix/menu/menu_mainbar")
menu_mainbar:show()

--右键节点主菜单
local menu_node = require("imguix/menu/menu_node")
menu_node:hide()
Event:addEventListener(enum.evt_keyboard.imgui_menu_node, function(event)
    if event and event.isHide then
        menu_node:hide()
    else
        menu_node:show(event)
    end

end)

-- 输入菜单
local menu_input = require("imguix/menu/menu_input")
menu_input:hide()
Event:addEventListener(enum.evt_keyboard.imgui_menu_input, function(event)
    if event and event.isHide then
        menu_input:hide()
    else
        menu_input:show(event)
    end
end)

--创建菜单
local menu_start = require("imguix/menu/menu_start")
menu_start:show()
Event:addEventListener(enum.evt_keyboard.imgui_menu_start, function(event)
    if event and event.isHide then
        menu_start:hide()
    else
        menu_start:show(event)
    end
end)


--节点的树形结构
local menu_tree = require("imguix/menu/menu_tree")
menu_tree:hide()
Event:addEventListener(enum.evt_keyboard.imgui_menu_tree, function(event)
    if event and event.isHide then
        menu_tree:hide()
    elseif event and event.isReversedSelect then
        if menu_tree:isShow() then
            menu_tree:hide()
        else
            menu_tree:show(event)
        end
    else
        menu_tree:show(event)
    end
end)

--节点的详情
local menu_detail = require("imguix/menu/menu_detail")
menu_detail:hide()
Event:addEventListener(enum.evt_keyboard.imgui_menu_detail, function(event)
    if event and event.isHide then
        menu_detail:hide()
    elseif event and event.isReversedSelect then
        if menu_detail:isShow() then
            menu_detail:hide()
        else
            menu_detail:show(event)
        end
    elseif event and event.isRefresh then
        menu_detail:refresh(event)
    else
        menu_detail:show(event)
    end
end)

--节点筛选
local menu_screensup = require("imguix/menu/menu_screensup")
menu_screensup:hide()
Event:addEventListener(enum.evt_keyboard.imgui_menu_screensup, function(event)
    if event and event.isHide then
        menu_screensup:hide()
    elseif event and event.isReversedSelect then
        if menu_screensup:isShow() then
            menu_screensup:hide()
        else
            menu_screensup:show(event)
        end
    elseif event and event.isRefresh then
        menu_screensup:refresh(event)
    else
        menu_screensup:show(event)
    end
end)

--新增节点
local popup_add = require("imguix/popup/add_dnode")
popup_add:hide()
Event:addEventListener(enum.evt_keyboard.imgui_popup_addnode, function(event)
    if event and event.isHide then
        popup_add:hide()
    else
        popup_add:show(event)
    end
end)














-- global for imgui
ImGui.HelpMarker = function(desc)
    ImGui.TextDisabled("(?)");
    if ImGui.IsItemHovered() then
        ImGui.BeginTooltip();
        ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35.0);
        ImGui.TextUnformatted(desc);
        ImGui.PopTextWrapPos();
        ImGui.EndTooltip();
    end
end